require 'unidecoder'

module Pc2r
  module Scrabble
    LETTER_VALUES = {
        %w(e a i n o r s t u l) => 1,
        %w(d m g) => 2,
        %w(b c p) => 3,
        %w(f h v) => 4,
        %w(j q) => 8,
        %w(k w x y z) => 10
    }

    def self.dict
      @dict ||= Set.new
    end

    def self.dictuonary
      if dict.empty?
        File.open('./../assets/ods.txt') do |file|
          file.each do |line|
            dict << line.chomp
          end
        end
      end
      dict
    end

    def self.score (word='')
      if word.respond_to? :to_s
        word.to_s.to_ascii.downcase.chars.map { |letter| letter_values[letter] }.compact.reduce(:+) || 0
      end
    end

    def self.letter_values
      Hash[*LETTER_VALUES.map do |letters, value|
        letters.map { |letter| [letter, value] }
      end.flatten]
    end
  end
end
