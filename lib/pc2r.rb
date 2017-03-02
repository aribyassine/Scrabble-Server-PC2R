require 'thread'
require 'socket'
require 'concurrent/array'
require 'matrix'

require_relative 'pc2r/scrabble'
require_relative 'pc2r/string'

module Pc2r
  Thread.abort_on_exception = true
  server = TCPServer.new (2000)
  clients = Concurrent::Array.new
  threads = Concurrent::Array.new

  loop do
    clients << c = server.accept
    threads << Thread.start(c) do |client|
      input = client.gets.chomp.to_s
      puts input.to_ascii
      client.puts(Scrabble.score input)
      client.puts(input.exist_in_dictuonary?)
      client.close
      clients.delete(client)
      threads.delete(Thread.current)
    end
  end
end
