require 'net/http'
require 'json'

class String

  def exist_in_wiktionary?
    url = "https://fr.wiktionary.org/w/api.php?action=query&titles=#{self.downcase}&format=json"
    uri = URI(URI.encode(url))
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    !json['query']['pages'].member?('-1')
  end

  def exist_in_dictuonary?
    Pc2r::Scrabble.dictuonary.include? self.chomp.downcase.to_ascii
  end
end

