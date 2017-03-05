require_relative 'player'

module Pc2r
  module Router

    def self.process(client)
      loop do
        request = client.gets.chomp.force_encoding('UTF-8').to_s
        #CONNEXION
        if /^CONNEXION\/[a-zA-Z]+\/$/ =~ request
          user = request.split('/').last
          connexion(user, client)
        end
        puts Player.find('ghiles').inspect
      end
    end

    def self.connexion(user, client)
      if Player.exist? user
        client.puts 'REFUS/'
      else
        Player.new(client, user)
      end
    end
  end
end
