module Pc2r
  class Bag

    LETTERS_DISTRIBUTION = {
        a: 9, b: 2, c: 2, d: 3,
        e: 15, f: 2, g: 2, h: 2,
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
    def take(n=1)
      # Fin de session ... plus de lettres dans le sac
      raise "Can't take #{n} letters i have only #{@letters.count}" if n > @letters.count
      @letters.pop n
    end
  end
end