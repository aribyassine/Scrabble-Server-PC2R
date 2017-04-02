require 'concurrent'
require 'timeout'
require 'singleton'
require_relative 'player'
require_relative 'grid'
require_relative 'bag'
require_relative 'tour'

module Pc2r
  class Session
    include Singleton
    attr_reader :phase, :time, :grid, :bag

    def init
      @grid = Grid.new
      @bag = Bag.new
      @time = configatron.deb
      @tasks = {}
    end

    def start
      init
      @tasks[:DEB] = debut(configatron.deb) do
        Player.broadcast('SESSION/')
        Thread.new { loop_forever }
      end
    end


    def tour
      return 1 if @tour.nil?
      @tour.number
    end

    private
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
          block.call
          @phase = :REC
          task.shutdown
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
          block.call
          @phase = :SOU
          task.shutdown
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
          block.call
          @phase = :RES
          task.shutdown
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
          @phase = :REC
          task.shutdown
        end
      end.execute
    end

  end
end
