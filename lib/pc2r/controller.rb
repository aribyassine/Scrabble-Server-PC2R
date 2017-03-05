require_relative 'player'

module Pc2r
  class Controller
    # @param client [TCPSocket]
    def initialize(client)
      @client = client
    end

    # @param user [String]
    def connexion(user)
      if Player.exist? user
        @client.puts 'REFUS/'
      else
        player = Player.new(@client, user)
        player.puts "BIENVENUE #{user}"
        player.broadcast "CONNECTE/#{user}/"
      end
    end


  end
end
