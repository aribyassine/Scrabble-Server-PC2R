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
    attr_reader :state, :time, :grid, :bag, :tour

    def initialize
      @state = :DEB
      @grid = Grid.new
      @bag = Bag.new
      @time = configatron.deb
      @tasks = {}
    end

    def deb
      @tasks[:DEB] = debut(configatron.deb) do
        Player.broadcast('SESSION/')
        start_tour
      end.execute
    end

    def start_tour
      @tour = Tour.new(@bag.take)
      @tasks[:REC] = recherche(configatron.rec) { Player.broadcast('RFIN/') }.execute
    end

    def tour
      return 1 if @tour.nil?
      @tour.number
    end
    private
    # @param time [Integer]
    def debut(time, &timout)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        @time = time
        time -= 1
        if @time <= 0
          timout.call
          @state = :REC
          task.shutdown
        end
      end
    end

    # @param time [Integer]
    def recherche(time, &block)
      Concurrent::TimerTask.new(execution_interval: 1, run_now: true) do |task|
        @tasks[:DEB].wait_for_termination
        @time = time
        time -= 1
        if @time <= 0
          block.call
          @state = :SOU
          task.shutdown
        end
      end
    end

  end
end
