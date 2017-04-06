require 'configatron'

module Pc2r
  class Config
    def self.load
      configatron.dictuonary = File.expand_path('../../assets/ods.txt', __dir__)
      configatron.web = File.expand_path('../web/scores', __dir__)
      configatron.port = 2017
      configatron.grid_size = 15

      # Timers
      configatron.deb = 2
      configatron.rec = 2
      configatron.sou = 2
      configatron.res = 2

      configatron.inter_session_time = 2
    end
  end
end