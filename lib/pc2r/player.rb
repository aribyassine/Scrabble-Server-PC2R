require 'concurrent/array'

module Pc2r
  class Player

    @@players = Concurrent::Array.new
    attr_reader :client, :name

    def initialize(client, name)
      @client = client
      @name = name
      @@players << self
    end

    class << self
      def all
        @@players
      end

      def exist?(user)
        @@players.each{|player| return true if player.name == user}
        false
      end

      def find(user)
        @@players.find{|player| player.name == user}
      end
    end
  end
end
