require 'configatron'

module Pc2r
  class Config
    def self.load
      configatron.dictuonary = File.expand_path('../../assets/ods.txt', __dir__)
      configatron.port = 2000
      configatron.grid_size = 15

      # Timers
      configatron.deb = 1
      configatron.rec = 1
      configatron.sou = 1
      configatron.res = 1
    end
  end
end