require 'sinatra'
require 'sinatra/reloader'
require_relative './models/film'
also_reload('./models/*')

get '/' do
  erb(:home)
end

get '/films' do
  @films = Film.all
  erb(:films)
end

get '/:film' do
  # p "this is the #{params[:film]} page"
  erb(:movie)
end
