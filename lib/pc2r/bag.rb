module Pc2r
  class Bag

    def initialize
      @letters = []
      configatron.bag_letters.each do |key, value|
        value.times { @letters << key }
      end
      @letters.shuffle!
    end

    # @param n [Integer]
    # @return [Array]
    def take(n=configatron.bag_take)
      @letters.pop n
    end
  end
end