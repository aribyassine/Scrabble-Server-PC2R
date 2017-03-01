require 'set'
require 'unidecoder'
s1 = Set.new

File.open('./assets/glaff-1.2.1.txt') do |file|
  file.each do |line|
    s1.add(line.split('|').first.to_ascii.downcase.gsub(/[^a-z]/, ''))
  end
end

File.open('./assets/words.txt','w+') do |file|
  s1.each do |word|
    file.puts(word)
  end
end

