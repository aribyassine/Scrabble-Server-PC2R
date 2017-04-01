require_relative 'pc2r/scrabble_server'
require_relative 'pc2r/string'
require_relative 'pc2r/grid'
require_relative 'config'
require 'pp'

module Pc2r

  Config.load

  Thread.abort_on_exception = true
  ScrabbleServer.new(2000).run

end

