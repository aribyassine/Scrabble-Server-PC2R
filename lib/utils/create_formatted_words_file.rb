require 'set'
require 'unidecoder'
dict = Set.new

File.open('./../assets/glaff-1.2.1.txt') do |file|
  file.each do |line|
    dict.add(line.split('|').first.to_ascii.downcase.gsub(/[^a-z]/, ''))
  end
end

File.open('./../assets/words.txt','w+') do |file|
  dict.each do |word|
    file.puts(word)
  end
end

