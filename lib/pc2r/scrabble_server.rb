require 'thread'
require 'socket'

require_relative 'router'

module Pc2r
  class ScrabbleServer

    def initialize(port)
      puts "*** Starting scrabble server on port : #{port}"
      @server = TCPServer.new (port)
      @threads = []
      run
    end

    def shutdown
      @server.close if @server
    end

    def run
      loop do
        @threads << Thread.start(@server.accept) do |client|
          Router::process client
        end
      end
    end

  end
end
