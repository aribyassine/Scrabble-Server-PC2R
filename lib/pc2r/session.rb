require 'concurrent'
require 'timeout'
require 'singleton'
require 'thread'
require 'json'
require_relative 'player'
require_relative 'grid'
require_relative 'bag'
require_relative 'tour'
require_relative 'string'

module Pc2r
  class Session < Mutex

    include Singleton
    attr_reader :phase, :time, :grid, :tour

    def start(first = true)
      @first_session = first
      @grid = Grid.new
      @bag = Bag.new
      @time = configatron.deb
      @tasks.values.each { |task| task.shutdown } if @tasks
      @tasks = Concurrent::Hash.new
      @tours = []
      Tour.reset_number
      @tasks[:DEB] = debut(configatron.deb) do
        Player.broadcast('SESSION/')
      end
      @loop = Thread.new { loop_forever }
    end

    def finish
      json = {}
      @tours.select { |tour| !tour.word.empty? }.each do |tour|
        win, word = tour.winner
        if json[win]
          json[win][:words] << word
          json[win][:score] += word.score
        else
          json[win] = {words: [word], score: word.score}
        end
      end
      File.open(configatron.web + "/#{Time.now.to_i}.json", 'w+') do |file|
        file.puts(json.to_json)
      end
      @tasks.values.each { |task| task.kill } if @tasks
      @loop.kill if @loop && Player.count == 0
    end

    # @param placement [String]
    # @param player [Player]
    def trouve(placement, player)
      synchronize {
        begin
          process_find_request placement, player
        rescue Exception => e
          if @tasks[:REC].running?
            player.puts "RINVALIDE/#{e.message}/"
          elsif @tasks[:SOU].running?
            player.puts "SINVALIDE/#{e.message}/"
          end
        end
      }
    end

    private

    def loop_forever
      # boucle des tour
      loop do
        # Début du tour
        if @phase != :DEB || !@first_session
          tirage = @bag.take
          break if tirage.empty?
          @tours << @tour = Tour.new(tirage)
          @tasks[:DEB].wait_for_termination unless @first_session
          Player.broadcast("TOUR/#{@grid}/#{tirage.join}/")
        end

        # Phase de recherche
        @tasks[:DEB].wait_for_termination
        @tasks[:REC] = recherche(configatron.rec) do
          Player.broadcast('RFIN/')
          @tasks[:REC].kill
        end
        @tasks[:REC].execute.wait_for_termination
        next unless @to_soumission

        # Phase de soumission
        @tasks[:SOU] = soumission(configatron.sou) do
          Player.broadcast('SFIN/')
          @tasks[:SOU].kill
        end
        @tasks[:SOU].execute.wait_for_termination

        # Phase de résultat
        @tasks[:RES] = resultat(configatron.res)
        @tasks[:RES].execute.wait_for_termination

      end
      # fin de session
      finish
      Concurrent::ScheduledTask.execute(configatron.inter_session_time) do
        start false
      end
    end

    # @param time [Integer]
    def debut(time, &block)
      @phase = :DEB
      @tours << @tour = Tour.new(@bag.take)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        synchronize {
          @time = time
          pp "debut #{@phase} -> #{@time.divmod(60)}"
          time -= 1
          if @time <= 0
            block.call
            @phase = :REC
            @tasks[:DEB].shutdown
          end
        }
      end.execute
    end

    # @param time [Integer]
    def recherche(time, &block)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        synchronize {
          @to_soumission = false
          @phase = :REC
          @time = time
          pp "recherche #{@phase} -> #{@time.divmod(60)}"
          time -= 1
          if @time <= 0
            @phase = :SOU
            block.call
          end
        }
      end
    end

    # @param time [Integer]
    def soumission(time, &block)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        synchronize {
          @phase = :SOU
          @time = time
          pp "soumission #{@phase} -> #{@time.divmod(60)}"
          time -= 1
          if @time <= 0
            @phase = :RES
            block.call
          end
        }
      end
    end

    # @param time [Integer]
    def resultat(time)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        synchronize {
          @phase = :RES
          @time = time
          time -= 1
          pp "resultat #{@phase} -> #{@time.divmod(60)}"
          if @time == configatron.res # first tick
            pp "cond #{@time == configatron.res}"
            vainqueur, mot = @tour.winner
            @grid.set! @tour.placement[vainqueur]
            Player.find(vainqueur).score += mot.score
            Player.broadcast("BILAN/#{mot}/#{vainqueur}/#{Player.scores}/")
          end
          if @time <= 0
            @phase = :REC
            @tasks[:RES].kill
          end
        }
      end
    end

    def process_find_request(placement, player)
      raise 'POS disposition des lettres invalide' unless @grid.valid? placement
      word = @grid.extract_word placement
      raise "DIC le mot <#{word}> n'est pas dans le dictionnaire" unless word.exist_in_dictuonary?
      used_letters = @grid.letters_used placement
      raise "POS le mot <#{word}> doit etre composé avec les lettres suivantes #{@tour.tirage.inspect}" unless used_letters.all? { |l| @tour.tirage.include? l.to_sym }
      if @tour.word[player.name].nil? || (word.score > @tour.word[player.name].score)
        @tour.word[player.name] = word
        @tour.placement[player.name] = placement
      else
        raise 'INF mot valide mais score inferieur a un precedent mot propose'
      end
      if @tasks[:REC].running?
        player.puts 'RVALIDE/'
        player.broadcast "RATROUVE/#{player.name}/"
        @to_soumission = true
        @tasks[:REC].kill
      elsif @tasks[:SOU].running?
        player.puts 'SVALIDE/'
      end
    end
  end
end
