require 'concurrent'
require 'timeout'
require 'singleton'
require 'thread'
require_relative 'player'
require_relative 'grid'
require_relative 'bag'
require_relative 'tour'

module Pc2r
  class Session < Mutex
    include Singleton
    attr_reader :phase, :time, :grid

    def start
      init
      @tasks[:DEB] = debut(configatron.deb) do
        Player.broadcast('SESSION/')
        Thread.new { loop_forever }
      end
    end

    # @param placement [String]
    # @param player [Player]
    def trouve(placement, player)
      begin
        if @grid.valid? placement
          word = @grid.extract_word placement
          raise "le mot <#{word}> n'est pas dans le dictionnaire" unless word.exist_in_dictuonary?
          used_letters = @grid.letters_used placement
          raise "le mot <#{word}> doit etre composé avec les lettres suivantes #{@tour.tirage.to_a.inspect}" unless @tour.tirage >= used_letters
          synchronize {
            if @tasks[:REC].running?
              player.puts 'RVALIDE/'
              player.broadcast "RATROUVE/#{player.name}/"
              @tour.found[player.name] = word
              @tasks[:REC].shutdown
            elsif @tasks[:SOU].running?
              player.puts 'SVALIDE/'

            end
          }
        else
          raise 'disposition des lettres invalide'
        end
      rescue Exception => e
        synchronize {
          if @tasks[:REC].running?
            player.puts "RINVALIDE/#{e.message}/"
          elsif @tasks[:SOU].running?
            player.puts "SINVALIDE/#{e.message}/"
          end
        }
      end
    end

    # @return [Integer]
    def tour
      return 1 if @tour.nil? # si phase = debut
      @tour.number
    end

    private

    def init
      @grid = Grid.new
      @bag = Bag.new
      @time = configatron.deb
      @tasks = {}
    end

    def loop_forever
      loop do
        # Début du tour
        tirage = @bag.take
        break if tirage.empty?
        @tour = Tour.new(tirage)

        # Phase de recherche
        @tasks[:REC] = recherche(configatron.rec) do
          Player.broadcast('RFIN/')
          @tasks[:SOU].kill
          @tasks[:RES].kill
        end

        # Phase de soumission
        @tasks[:SOU] = soumission(configatron.sou) do
          Player.broadcast('SFIN/')
        end

        #Phase de résultat
        @tasks[:RES] = soumission(configatron.sou) do
          Player.broadcast('BILAN/')
        end
        @tasks[:RES].wait_for_termination

      end
      # todo fin de session
    end

    # @param time [Integer]
    def debut(time, &block)
      @phase = :DEB
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        @time = time
        time -= 1
        if @time <= 0
          synchronize {
            block.call
            @phase = :REC
            task.shutdown
          }
        end
      end.execute
    end

    # @param time [Integer]
    def recherche(time, &block)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        @tasks[:DEB].wait_for_termination
        @time = time
        time -= 1
        if @time <= 0
          synchronize {
            block.call
            @phase = :SOU
            task.shutdown
          }
        end
      end.execute
    end

    # @param time [Integer]
    def soumission(time, &block)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        @tasks[:REC].wait_for_termination
        @time = time
        time -= 1
        if @time <= 0
          synchronize {
            block.call
            @phase = :RES
            task.shutdown
          }
        end
      end.execute
    end

    # @param time [Integer]
    def resultat(time, &block)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        @tasks[:SOU].wait_for_termination
        block.call if time == configatron.res # first tick
        @time = time
        time -= 1
        if @time <= 0
          synchronize {
            @phase = :REC
            task.shutdown
          }
        end
      end.execute
    end

  end
end
