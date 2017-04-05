require 'socket'
require 'spec_helper'
require 'pp'
require_relative '../lib/pc2r/scrabble_server'
require_relative '../lib/pc2r/config'

RSpec.describe Pc2r do
  Thread.abort_on_exception = true
  Thread.report_on_exception = true
  Pc2r::Config.load
  serveur = Pc2r::ScrabbleServer.new(configatron.port)
  Thread.new { serveur.run }

  a = TCPSocket.new('localhost', configatron.port)
  b = TCPSocket.new('localhost', configatron.port)

  it 'has a version number' do
    expect(Pc2r::VERSION).not_to be nil
  end

  it 'should connect' do
    a.puts 'CONNEXION/a/'
    expect(a.gets.chomp).to match(/BIENVENUE\/0{#{configatron.grid_size ** 2}}\/[A-Z]{7}\/1\*a\*0\/DEB\/[[:digit:]]*\//)
    b.puts 'CONNEXION/a/'
    expect(b.gets.chomp).to eq('REFUS/')
    b.puts 'CONNEXION/b/'
    expect(b.gets.chomp).to match(/BIENVENUE\/0{#{configatron.grid_size ** 2}}\/[A-Z]{7}\/1\*a\*0\*b\*0\/DEB\/[[:digit:]]*\//)
    expect(a.gets.chomp).to eq('CONNECTE/b/')
  end

  it 'should start session' do
    expect(a.gets.chomp).to eq('SESSION/')
    expect(b.gets.chomp).to eq('SESSION/')
  end

  it 'should send RFIN/' do
    expect(a.gets.chomp).to eq('RFIN/')
    expect(b.gets.chomp).to eq('RFIN/')
  end

  it 'should send tour 2' do
    replay_a, replay_b = a.gets.chomp ,b.gets.chomp
    expect(replay_a).to match(/TOUR\/([A-Z]|0){#{configatron.grid_size ** 2}}\/[A-Z]{7}/)
    expect(replay_b).to match(/TOUR\/([A-Z]|0){#{configatron.grid_size ** 2}}\/[A-Z]{7}/)
    expect(replay_a).to eq(replay_b)
  end

  it 'should send public message' do
    msg = 'hello'
    a.puts "ENVOI/#{msg}/"
    expect(b.gets.chomp).to eq("RECEPTION/#{msg}/")
  end

  it 'should send private message' do
    msg = 'hello'
    a.puts "PENVOI/b/#{msg}/"
    expect(b.gets.chomp).to eq("PRECEPTION/#{msg}/a/")
  end

  it 'should send RFIN/' do
    expect(a.gets.chomp).to eq('RFIN/')
    expect(b.gets.chomp).to eq('RFIN/')
  end

  it 'should send tour 3' do
    replay_a, replay_b = a.gets.chomp ,b.gets.chomp
    expect(replay_a).to match(/TOUR\/([A-Z]|0){#{configatron.grid_size ** 2}}\/[A-Z]{7}/)
    expect(replay_b).to match(/TOUR\/([A-Z]|0){#{configatron.grid_size ** 2}}\/[A-Z]{7}/)
    expect(replay_a).to eq(replay_b)
  end

  it 'should disconnect' do
    a.puts 'SORT/a/'
    expect(a.gets).to be nil
    a.close
    expect(b.gets.chomp).to eq('DECONNEXION/a/')
    b.puts 'SORT/b/'
    expect(b.gets).to be nil
    b.close
  end
end
