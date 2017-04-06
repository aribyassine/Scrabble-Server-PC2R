require 'sinatra'
require 'json'
require_relative '../pc2r/configutation'
Pc2r::Configutation.load

set :bind, configatron.web_bind
set :port, configatron.web_port

get '/' do
  best_scores = []
  parse_json(configatron.web_dir).each_pair do |date, session|
    best = {}
    session.each_pair do |user_name, game|
      best = {
          date: date, name: user_name, score: game['score'], id: session[:id], words: game['words']
      } if best.empty? || (game['score'] > best[:score] if game.is_a? Hash)
    end
    best_scores << best
  end

  erb :index, :locals => {best_scores: best_scores}
end

get '/user/:name' do |name|
  games = []
  parse_json(configatron.web_dir).each_pair do |date, session|
    if session[name]
      session[name][:date] = date
      session[name][:id] = session[:id]
      games << session[name]
    end
  end
  erb :user, locals: {name: name, stat: games}
end

get '/session/:id' do |id|
  json = JSON.parse(File.readlines(configatron.web_dir+"/#{id}.json").first)
  erb :session, locals: {json: json, time: id}
end

def parse_json(path)
  sessions = {}
  Dir.foreach(path) do |item|
    next unless item =~ /[0-9]*\.json/
    key = Time.at(item.split('.').first.to_i).ctime
    sessions[key] = JSON.parse(File.readlines(path+"/#{item}").first)
    sessions[key][:id] = item.split('.').first.to_i
  end
  sessions
end