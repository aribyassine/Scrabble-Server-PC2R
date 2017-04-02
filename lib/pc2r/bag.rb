module Pc2r
  class Bag

    LETTERS_DISTRIBUTION = {
        A: 9, B: 2, C: 2, D: 3,
        E: 15, F: 2, G: 2, H: 2,
        i: 8, j: 1, k: 1, l: 5,
        m: 3, n: 6, o: 6, p: 2,
        q: 1, r: 6, s: 6, t: 6,
        u: 6, v: 2, w: 1, x: 1,
        y: 1, z: 1
    }

    def initialize
      @letters = []
      LETTERS_DISTRIBUTION.each do |key, value|
        value.times { @letters << key }
      end
      @letters.shuffle!
    end

    # @param n [Integer]
    # @return [Array]
    def take(n=7)
      @letters.pop n
    end
  end
end