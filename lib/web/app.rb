require 'sinatra'
require 'json'

def load_files(path)
  sessions = {}
  Dir.foreach(File.expand_path('../web/scores', __dir__)) do |item|
    next unless item =~ /[0-9]*\.json/
    key = Time.at(item.split('.').first.to_i).ctime
    sessions[key] = JSON.parse(File.readlines(path+"/#{item}").first)
    sessions[key][:id] = item.split('.').first.to_i
  end
  sessions
end

get '/' do
  sessions = load_files(File.expand_path('../web/scores', __dir__))
  best_scores = []
  sessions.each_pair do |date, session|
    best = {}
    session.each_pair do |user_name, game|
      best = {
          date: date, name: user_name, score: game['score'], id: session[:id], words: game['words']
      } if best.empty? || (game['score'] > best[:score] if game.is_a? Hash)
    end
    best_scores << best
  end

  erb :index, :locals => {:best_scores => best_scores}
end

get '/user/:name' do |name|
  erb :user, :locals => {:name => name}
end

get '/session/:id' do |id|
  json = JSON.parse(File.readlines(File.expand_path('../web/scores', __dir__)+"/#{id}.json").first)
  erb :session, :locals => {:json => json,:time => id}
end