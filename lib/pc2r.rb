require_relative 'pc2r/scrabble'
module Pc2r
  liste = gets.strip.split
  liste.each do |mot|
    Scrabble.new mot
    puts "#{mot} => #{Scrabble.new(mot).score}"
  end
end
