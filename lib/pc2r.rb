require_relative 'pc2r/scrabble_server'
require_relative 'pc2r/string'
require_relative 'pc2r/bag'
require 'pp'
module Pc2r

  bag = Bag.new
  5.times do
    begin
      pp bag.take(5)
    rescue
      pp 'fin session'
    end

  end

=begin
    Thread.abort_on_exception = true
    ScrabbleServer.new(2000).run
=end

end

