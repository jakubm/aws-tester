require 'sinatra'
require 'puma'

set :port, ENV['PORT']

counter = 0

get '/' do
  counter += 1
  counter.to_s
end
