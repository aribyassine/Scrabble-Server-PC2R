require 'unidecoder'

module Pc2r
  module Scrabble
    LETTER_VALUES = {
        %w(E A I N O R S T U L) => 1,
        %w(D M G) => 2,
        %w(B C P) => 3,
        %w(F H V) => 4,
        %w(J Q) => 8,
        %w(K W X Y Z) => 10
    }

    DICT_FILE = './../assets/ods.txt'

    # @return [Set]
    def self.dictuonary
      if dict.empty?
        File.open(DICT_FILE) do |file|
          file.each do |line|
            dict << line.chomp
          end
        end
      end
      dict
    end

    # @return [Integer]
    def self.score (word='')
      if word.respond_to? :to_s
        word.to_s.to_ascii.upcase.chars.map { |letter| letter_values[letter] }.compact.reduce(:+) || 0
      end
    end

    private
    def self.letter_values
      Hash[*LETTER_VALUES.map do |letters, value|
        letters.map { |letter| [letter, value] }
      end.flatten]
    end

    def self.dict
      @dict ||= Set.new
    end
  end
end
