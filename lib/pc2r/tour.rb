require_relative 'player'

module Pc2r
  class Tour
    @@number = 1
    attr_accessor :number, :tirage

    # @param tirage [Array]
    def initialize(tirage)
      @number = @@number
      @@number += 1
      @tirage = tirage
      Player.broadcast("TOUR/#{Session.instance.grid}/#{tirage.join}")
    end

  end
end
