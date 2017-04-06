require_relative 'pc2r/scrabble_server'
require_relative 'pc2r/string'
require_relative 'pc2r/grid'
require_relative 'pc2r/bag'
require_relative 'pc2r/configutation'
require 'pp'

module Pc2r
=begin
  h = {}
  h[:a] = 'lol'
  h[:f] = 'wwwwwwww'
  h[:e] = 'lofzfl'
  h[:d] = 'lolr'
  h[:c] = 'wwwwwwww'
  h[:b] = 'lolrze'

  pp h
  pp h.max_by { |word| word.last.score }
=end
  Configutation.load
  pp 'hello'.score()
  Thread.abort_on_exception = true
  ScrabbleServer.new(configatron.port).run

end

