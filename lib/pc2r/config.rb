require 'configatron'

module Pc2r
  class Config
    def self.load
      configatron.dictuonary = File.expand_path('../../assets/ods.txt', __dir__)
      configatron.port = 2017
      configatron.grid_size = 15

      # Timers
      configatron.deb = 20
      configatron.rec = 60 * 5
      configatron.sou = 60 * 2
      configatron.res = 10

      configatron.inter_session_time = 60 * 2
    end
  end
end