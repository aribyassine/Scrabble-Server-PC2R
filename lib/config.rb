require 'configatron'

module Pc2r
  class Config
    def self.load
      configatron.dictuonary = File.expand_path('../../assets/ods.txt', __FILE__)
      configatron.port = 2000
      configatron.grid_size = 15
    end
  end
end