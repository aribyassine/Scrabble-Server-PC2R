require_relative 'pc2r/scrabble_server'
require_relative 'pc2r/string'
module Pc2r

    Thread.abort_on_exception = true
    ScrabbleServer.new(2000).run

end

