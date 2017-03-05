require_relative 'player'

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
      Player.new(client, user)
    end
  end
end