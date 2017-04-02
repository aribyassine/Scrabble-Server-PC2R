require 'net/http'
require 'json'
require 'unidecoder'

class String
  LETTER_VALUES = {
      %w(E A I N O R S T U L) => 1,
      %w(D M G) => 2,
      %w(B C P) => 3,
      %w(F H V) => 4,
      %w(J Q) => 8,
      %w(K W X Y Z) => 10
  }

  def exist_in_wiktionary?
    url = "https://fr.wiktionary.org/w/api.php?action=query&titles=#{self.downcase}&format=json"
    uri = URI(URI.encode(url))
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    !json['query']['pages'].member?('-1')
  end

  def exist_in_dictuonary?
    String.dictuonary.include? self.chomp.upcase.to_ascii
  end

  # @return [Integer]
  def score
    self.to_ascii.upcase.chars.map { |letter| letter_values[letter] }.compact.reduce(:+) || 0
  end

  private
  def letter_values
    @@letter_values ||= Hash[*LETTER_VALUES.map do |letters, value|
      letters.map { |letter| [letter, value] }
    end.flatten]
  end

  # @return [Set]
  def self.dictuonary
    if dict.empty?
      File.open(configatron.dictuonary) do |file|
        file.each do |line|
          dict << line.chomp
        end
      end
    end
    dict
  end

  def self.dict
    @@dict ||= Set.new
  end
end

