require 'net/http'
require 'json'
require_relative 'pc2r/version'
require_relative 'server'

module Pc2r
  Server.new 'lol'
  loop do
    puts 'saisir un mot pour savoir si il existe'
    mot = gets.strip#.force_encoding('ascii')
    url = "https://fr.wiktionary.org/w/api.php?action=query&titles=#{mot}&format=json"
    uri = URI(URI.encode(url))
    puts uri
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    puts json['query']['pages'].has_key?('-1') ? "#{mot} n'existe pas" : "#{mot} existe"
  end
end
