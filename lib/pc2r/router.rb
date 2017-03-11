require_relative 'controller'

module Pc2r
  module Router

    # @param client [TCPSocket]
    def self.process(client)
      controller = Controller.new(client)

      loop do
        request = client.gets || break
        request = request.chomp.force_encoding('UTF-8').to_s
        begin
          route, params = parse(request)
          puts "route : '#{route.inspect}'  => params : #{params}"
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
          next
        end

        # Utilisateur authentifié
        if controller.authenticated?
          case route
            when :sort then
              controller.sort(params[0])
            when :envoi then
              controller.envoi(params[0])
            when :penvoi then
              controller.penvoi(params[0], params[1])
          end
        else
          # Utilisateur non authentifié
          controller.connexion(params[0]) if route == :connexion
        end

      end
    end

    private
    @user = '[a-zA-Z]+'
    @msg = '.+'

    @regexp = {
        :connexion => /^CONNEXION\/(#{@user})\/$/,
        :sort => /^SORT\/(#{@user})\/$/,
        :envoi => /^ENVOI\/(#{@msg})\/$/,
        :penvoi => /^PENVOI\/(#{@user})\/(#{@msg})\/$/,
    }

    def self.parse(request)
      found = @regexp.find { |k, v| v =~ request }
      found = found.first if found
      return [found, request.match(@regexp[found]).captures] if found
    end

  end
end
