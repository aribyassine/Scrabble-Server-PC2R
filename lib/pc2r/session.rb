require 'concurrent'
require 'timeout'
require_relative 'player'
require_relative 'grid'
require_relative 'bag'

module Pc2r
class Session
  attr_reader :state
  def initialize
    @state = :DEB
    @grid = Grid.new
    @bag = Bag.new

  end

  def start

  end
end
end
