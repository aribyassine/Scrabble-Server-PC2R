require 'concurrent/array'

module Pc2r
  class Player

    @@players = Concurrent::Array.new
    attr_reader :client, :name

    # @param client [TCPSocket]
    # @param name [String]
    def initialize(client, name)
      @client = client
      @name = name
      @@players << self
    end

    # @param msg [String]
    def broadcast(msg)
      @@players.each { |player| player.puts msg unless player == self }
    end

    def puts (obj='', *arg)
      @client.puts(obj, arg)
    end

    def destroy
      @@players.delete self
      @client.close
      Thread.current.kill
    end

    def alone?
      @@players.count == 1 && @@players.include?(self)
    end

    class << self

      # @return [Array]
      def all
        @@players
      end

      # @param user [String]
      def exist?(user)
        @@players.each { |player| return true if player.name == user }
        false
      end

      # @param user [String]
      # @return [Player]
      def find(user)
        @@players.find { |player| player.name == user }
      end
    end
  end
end
