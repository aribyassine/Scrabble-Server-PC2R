require_relative 'player'

module Pc2r
  class Tour
    @@number = 1
    attr_reader :number, :tirage
    attr_accessor :word, :placement

    # @param tirage [Array]
    def initialize(tirage)
      @number = @@number
      @@number += 1
      @tirage = tirage
      @word = {}
      @placement = {}
    end

    def winner
      @word.max_by { |word| word.last.score }
    end

    def self.reset_number
      @@number = 1
    end
  end
end
