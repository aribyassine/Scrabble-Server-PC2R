require_relative 'pc2r/scrabble_server'
require_relative 'pc2r/string'
require_relative 'pc2r/grid'
require_relative 'pc2r/bag'
require_relative 'pc2r/configutation'
require 'pp'

module Pc2r

  Configutation.load
  pp 'hello'.score()
  Thread.abort_on_exception = true
  ScrabbleServer.new(configatron.port).run

end

