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
