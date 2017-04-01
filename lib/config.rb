require 'configatron'

module Pc2r
  class Config
    def self.load
      configatron.dictuonary = File.expand_path('../../assets/ods.txt', __FILE__)
    end
  end
end