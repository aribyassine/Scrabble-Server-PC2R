require_relative 'controller'

module Pc2r
  module Router

    # @param client [TCPSocket]
    def self.process(client)
      controller = Controller.new(client)

      loop do
        request = client.gets.chomp.force_encoding('UTF-8').to_s
        route = parse request
        params = request.match(@capture[route]).captures
        # Utilisateur authentifié
        if controller.authenticated?
          case route
            when :sort    then controller.sort(params[0])
            when :envoi   then controller.envoi(params[0])
            when :penvoi  then controller.penvoi(params[0], params[1])
            else
              # invalide request
              puts request
          end
=begin
          # SORT/user/
          if /^SORT\/#{@user}\/$/ =~ request
            user = request.split('/').last
            controller.sort(user)
            # ENVOI/message/
          elsif /^ENVOI\/#{@msg}\/$/ =~ request
            msg = request.split('/').last
            controller.envoi(msg)
            # PENVOI/user/message/
          elsif /^PENVOI\/#{@user}\/#{@msg}\/$/ =~ request
            user = request.split('/')[1]
            msg = request.split('/')[2]
            controller.penvoi(user, msg)
            # RECEPTION/message/
          end
=end
          # Utilisateur non authentifié
        else
          # CONNEXION/user/
          if /^CONNEXION\/#{@user}\/$/ =~ request
            user = request.split('/').last
            controller.connexion(user)
          end
        end
      end
    end

    private
    @user = '[a-zA-Z]+'
    @msg = '.+'

    @match = {
        :connexion    => /^CONNEXION\/#{@user}\/$/,
        :sort         => /^SORT\/#{@user}\/$/,
        :envoi        => /^ENVOI\/#{@msg}\/$/,
        :penvoi       => /^PENVOI\/#{@user}\/#{@msg}\/$/,
    }

    @captures = {
        :connexion    => /^CONNEXION\/(#{@user})\/$/,
        :sort         => /^SORT\/(#{@user})\/$/,
        :envoi        => /^ENVOI\/(#{@msg})\/$/,
        :penvoi       => /^PENVOI\/(#{@user})\/(?<msg>#{@msg})\/$/,
    }

    def self.parse(request)
      found = @match.find { |k, v| v =~ request }
      found.first unless found.nil?
    end

  end
end
