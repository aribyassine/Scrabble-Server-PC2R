require_relative 'controller'

module Pc2r
  class Router

    # @param client [TCPSocket]
    def initialize(client)
      @socket = client
      @controller = Controller.new(client)

      user = '[a-zA-Z]+'
      msg = '.+'
      placement = "([A-Z]|0){#{configatron.grid_size ** 2}}"

      @regexp = {
          connexion: /^CONNEXION\/(#{user})\/$/,
          sort: /^SORT\/(#{user})\/$/,
          trouve: /^TROUVE\/(#{placement})\/$/,
          envoi: /^ENVOI\/(#{msg})\/$/,
          penvoi: /^PENVOI\/(#{user})\/(#{msg})\/$/,
      }

    end

    def process
      loop do
        begin
          request = @socket.gets.chomp.force_encoding('UTF-8').to_s
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
          if @player
            @player.destroy
          else
            @socket.close
            Thread.current.kill
          end
          break
        end

        begin
          route, params = parse(request)
          puts "route : '#{route.inspect}'  => params : #{params}"
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
          next
        end

        # Utilisateur authentifié
        if @player
          case route
            when :sort then
              @controller.sort(params[0])
            when :envoi then
              @controller.envoi(params[0])
            when :penvoi then
              @controller.penvoi(params[0], params[1])
            when :trouve then
              @controller.trouve(params[0])
          end
        else
          # Utilisateur non authentifié
          @player = @controller.connexion(params[0]) if route == :connexion
        end

      end
    end

    private
    def parse(request)
      found = @regexp.find { |k, v| v =~ request }
      found = found.first if found
      [found, request.match(@regexp[found]).captures] if found
    end

  end
end
