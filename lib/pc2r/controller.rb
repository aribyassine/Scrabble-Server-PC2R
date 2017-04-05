require_relative 'player'
require_relative 'session'

module Pc2r
  class Controller

    # @param client [TCPSocket]
    def initialize(client)
      @socket = client
      @session = Session.instance
    end

    # @param user [String]
    def connexion(user)
      if Player.exist? user
        @socket.puts 'REFUS/'
      else
        @session.synchronize { # la session est un singleton, on peut donc se synchroniser dessu
          @player = Player.new(@socket, user)
          @session.start if @player.alone?
        }
        @player.puts "BIENVENUE/#{@session.grid}/#{@session.tour.tirage.join}/#{Player.scores}/#{@session.phase}/#{@session.time}/"
        @player.broadcast "CONNECTE/#{user}/"
      end
      @player
    end

    # @param user [String]
    def sort(user)
      if @player.name == user
        @player.destroy
      end
    end

    # @param placement [String]
    def trouve(placement)
      @session.trouve(placement, @player) if  @session.synchronize { @session.phase == :REC || @session.phase == :SOU }
    end

    # @param msg [String]
    def envoi(msg)
      @player.broadcast "RECEPTION/#{msg}/"
    end

    # @param user [String]
    # @param msg [String]
    def penvoi(user, msg)
      dst = Player.find(user)
      src = @player.name
      if dst
        dst.puts "PRECEPTION/#{msg}/#{src}/"
      end
    end

  end
end
