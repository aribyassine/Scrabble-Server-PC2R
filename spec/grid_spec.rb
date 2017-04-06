require 'rspec'
require_relative '../lib/pc2r/grid'
require_relative '../lib/pc2r/string'
require_relative '../lib/pc2r/configutation'

describe 'Grid' do


  Pc2r::Configutation.load
  grid = Pc2r::Grid.new

  it 'should add first word <salut>' do
    word = 's00000000000000'+
        'a00000000000000'+
        'l00000000000000'+
        'u00000000000000'+
        't00000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'
    expect(grid.letters_used(word)).to eq('salut'.chars.to_set)
    expect(grid.set! word).to eq 'salut'
    puts grid.pretty

  end
  it 'should add word <lutte>' do
    word = 's00000000000000'+
        'a00000000000000'+
        'lutte0000000000'+
        'u00000000000000'+
        't00000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'
    expect(grid.letters_used(word)).to eq('utte'.chars.to_set)
    expect(grid.set! word).to eq 'lutte'
    puts grid.pretty
  end
  it 'should add word <botte>' do
    word =
        's00b00000000000'+
        'a00o00000000000'+
        'lutte0000000000'+
        'u00t00000000000'+
        't00e00000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'
    expect(grid.letters_used(word)).to eq('bote'.chars.to_set)
    expect(grid.set! word).to eq 'botte'
    puts grid.pretty
  end
  it 'should add word <sarbacane>' do
    word =
        'sarbacane000000'+
        'a00o00000000000'+
        'lutte0000000000'+
        'u00t00000000000'+
        't00e00000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'
    expect(grid.letters_used(word)).to eq('aracane'.chars.to_set)
    expect(grid.set! word).to eq 'sarbacane'
    puts grid.pretty
  end
  it 'should raise an Exception' do
    word =
        'sarbacane000000'+
        'a00o00000000000'+
        'lutte0000000000'+
        'u00t00000000000'+
        't00e00000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '000000000000000'+
        '0000000000000si'
    expect{grid.set! word}.to raise_exception 'POS disposition des lettres invalide'
    puts grid.pretty
  end
end