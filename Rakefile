require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :test => :spec

task :default => :serve

task :serve do
  ruby 'lib/pc2r.rb'
end

task :web do
  ruby 'lib/web/app.rb'
end
