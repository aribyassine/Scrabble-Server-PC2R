require_relative 'player'

module Pc2r
  class Tour
    @@number = 1
    attr_reader :number
    attr_accessor :found

    # @param tirage [Array]
    def initialize(tirage)
      @number = @@number
      @@number += 1
      @tirage = tirage
      @found = {}
      Player.broadcast("TOUR/#{Session.instance.grid}/#{tirage.join}")
    end

    def tirage
      @tirage.to_set
    end

  end
end
