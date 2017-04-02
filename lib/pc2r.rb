require_relative 'pc2r/scrabble_server'
require_relative 'pc2r/string'
require_relative 'pc2r/grid'
require_relative 'pc2r/bag'
require_relative 'pc2r/config'
require 'pp'

module Pc2r
  a = 1
  Concurrent::TimerTask.execute(execution_interval: 1){ pp a += 1 }
  sleep(10)
=begin
  Config.load
  bag = Bag.new
  5.times {
    pp bag.take 25
  }
=end
=begin
  Thread.abort_on_exception = true
  ScrabbleServer.new(configatron.port).run
=end

end

