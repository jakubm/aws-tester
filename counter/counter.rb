require 'sinatra'
require 'puma'
require 'redis'

set :port, ENV['PORT']
redishost = ENV['REDISHOST']

counter = 0

get '/' do
  redis = Redis.new(host: redishost)
  counter = redis.incr('counter')
  counter.to_s
end
