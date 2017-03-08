require_relative 'controller'

module Pc2r
  module Router

    # @param client [TCPSocket]
    def self.process(client)
      controller = Controller.new(client)
      loop do
        request = client.gets.chomp.force_encoding('UTF-8').to_s
        # Utilisateur authentifié
        if controller.authenticated?
          # SORT/user/
          if /^SORT\/[a-zA-Z]+\/$/ =~ request
            user = request.split('/').last
            controller.sort(user)
            # ENVOI/message/
          elsif /^ENVOI\/.+\/$/ =~ request
            msg = request.split('/').last
            # PENVOI/user/message/
          elsif /^PENVOI\/[a-zA-Z]+\/.+\/$/ =~ request
            user = request.split('/')[1]
            msg = request.split('/')[2]
            # RECEPTION/message/
          elsif /^RECEPTION\/.+\/$/ =~ request
            msg = request.split('/').last
            # PRECEPTION/message/user/
          elsif /^PRECEPTION\/.+\/[a-zA-Z]+\/$/ =~ request
            msg = request.split('/')[1]
            user = request.split('/')[2]
          end

          # Utilisateur non authentifié
        else
          # CONNEXION/user/
          if /^CONNEXION\/[a-zA-Z]+\/$/ =~ request
            user = request.split('/').last
            controller.connexion(user)
          end
        end
      end
    end
  end
end
