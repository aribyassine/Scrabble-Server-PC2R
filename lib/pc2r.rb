require 'thread'
require 'socket'

require_relative 'pc2r/router'

module Pc2r

  Thread.abort_on_exception = true
  server = TCPServer.new (2000)

  loop do
    c = server.accept
    Thread.start(c) do |client|
      Router::process client
    end
  end
end
