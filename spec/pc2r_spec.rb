require 'spec_helper'
require 'socket'

RSpec.describe Pc2r do

  server = TCPSocket.new('localhost', 2000)

  it 'has a version number' do
    expect(Pc2r::VERSION).not_to be nil
  end

  it 'should connect' do
    server.puts 'CONNEXION/user/'
    expect(server.gets.chomp).to eq('BIENVENUE/user/')
  end

  it 'should disconnect' do
    server.puts 'SORT/user/'
    expect(server.gets).to be nil
    server.close
  end
end
