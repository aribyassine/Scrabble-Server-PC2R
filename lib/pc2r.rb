require_relative 'pc2r/scrabble_server'
module Pc2r
    Thread.abort_on_exception = true
    ScrabbleServer.new 2000
end

