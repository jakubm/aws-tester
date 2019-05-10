require 'sinatra'
require 'puma'
require 'httparty'

counterhost = ENV['COUNTERHOST']
counterport = ENV['COUNTERPORT']

set :port, ENV['PORT']

get '/' do
  counter = HTTParty.get("http://#{counterhost}:#{counterport}/").body
  counter |= 999
  output = "<pre>counter: #{counter}"
  output + "</pre>"
end
