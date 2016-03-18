require 'sinatra'
require 'rubygems'
require 'oauth'
require 'json'


class Hashtag
  def initialize(alou)
    $hashtagid = alou
    load 'searchtweet.rb'
  end
end
set :bind, '0.0.0.0'
set :public_folder, 'public'
get '/hashtag/:name' do
  nome = params['name']
  if nome.nil?
    status 404
  else
    usuario = Hashtag.new(nome)
    redirect '/index.html'
  end
end
