require_relative 'controller'

module Pc2r
  module Router

    # @param client [TCPSocket]
    def self.process(client)
      controller = Controller.new(client)
      loop do
        request = client.gets.chomp.force_encoding('UTF-8').to_s
        #CONNEXION
        if /^CONNEXION\/[a-zA-Z]+\/$/ =~ request
          user = request.split('/').last
          controller.connexion(user)
        elsif /^SORT\/[a-zA-Z]+\/$/ =~ request

        end
      end
    end

  end
end
