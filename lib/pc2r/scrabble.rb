module Pc2r
  class Scrabble
    LETTER_VALUES = {
        %w(e a i n o r s t u l) => 1,
        %w(d m g) => 2,
        %w(b c p) => 3,
        %w(f h v) => 4,
        %w(j q) => 8,
        %w(k w x y z) => 10
    }

    def initialize(word)
      if word.respond_to? :to_s
      then
        @word = word.to_s.downcase.gsub(/[^a-z]/, '')
      else
        @word = ''
      end
    end

    def score
      @word.chars.map { |letter| letter_values[letter] }.compact.reduce(:+) || 0
    end

    private

    def letter_values
      Hash[*LETTER_VALUES.map do |letters, value|
        letters.map { |letter| [letter, value] }
      end.flatten]
    end
  end
end
