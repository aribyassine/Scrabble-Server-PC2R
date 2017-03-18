require 'spec_helper'
require 'socket'

RSpec.describe Pc2r do

  s1 = TCPSocket.new('localhost', 2000)
  s2 = TCPSocket.new('localhost', 2000)

  it 'has a version number' do
    expect(Pc2r::VERSION).not_to be nil
  end

  it 'should connect' do
    s1.puts 'CONNEXION/a/'
    expect(s1.gets.chomp).to eq('BIENVENUE/a/')
    s2.puts 'CONNEXION/a/'
    expect(s2.gets.chomp).to eq('REFUS/')
    s2.puts 'CONNEXION/b/'
    expect(s2.gets.chomp).to eq('BIENVENUE/b/')
    expect(s1.gets.chomp).to eq('CONNECTE/b/')
  end

  it 'should disconnect' do
    s1.puts 'SORT/a/'
    expect(s1.gets).to be nil
    s1.close
    expect(s2.gets.chomp).to eq('DECONNEXION/a/')
    s2.puts 'SORT/b/'
    expect(s2.gets).to be nil
    s2.close
  end
end
