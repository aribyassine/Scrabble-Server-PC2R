require 'net/http'
require 'json'
require 'unidecoder'

class String

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

  def exist?
    if configatron.wiktionary
      exist_in_wiktionary?
    else
      exist_in_dictuonary?
    end
  end

  # @return [Integer]
  def score
    self.to_ascii.upcase.chars.map { |letter| configatron.letters_values[letter.to_sym] }.compact.reduce(:+) || 0
  end

  private

  # @return [Set]
  def self.dictuonary
    if dict.empty?
      File.open(configatron.dict) do |file|
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

