require 'configatron'

module Pc2r
  class Config
    def self.load
      configatron.dictuonary = File.expand_path('../../assets/ods.txt', __dir__)
      configatron.web = File.expand_path('../../web', __dir__)
      configatron.port = 2017
      configatron.grid_size = 15

      # Timers
      configatron.deb = 10
      configatron.rec = 60 * 2
      configatron.sou = 45
      configatron.res = 5

      configatron.inter_session_time = 30
    end
  end
end