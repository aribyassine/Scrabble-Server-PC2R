require 'net/http'
require 'json'

class String
  def self.dictuonary

  end
  def exist_in_wiktionary?
      url = "https://fr.wiktionary.org/w/api.php?action=query&titles=#{self.downcase}&format=json"
      uri = URI(URI.encode(url))
      response = Net::HTTP.get(uri)
      json = JSON.parse(response)
      ! json['query']['pages'].member?('-1')
  end

  def exist_in_file?

  end
end