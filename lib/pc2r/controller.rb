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
        @player = Player.new(@client, user)
        @player.puts "BIENVENUE/#{user}/"
        @player.broadcast "CONNECTE/#{user}/"
      end
      @player
    end

    # @param user [String]
    def sort(user)
      if @player.name == user
        @player.broadcast "DECONNEXION/#{user}/"
        @player.destroy
      end
    end

    # @param msg [String]
    def envoi(msg)
      @player.broadcast "RECEPTION/#{msg}/"
    end

    # @param user [String]
    # @param msg [String]
    def penvoi(user,msg)
      dst = Player.find(user)
      src = @player.name
      if dst
        dst.puts "PRECEPTION/#{msg}/#{src}/"
      end
    end

  end
end
