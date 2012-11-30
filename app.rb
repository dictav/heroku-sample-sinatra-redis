require 'rubygems'
require 'sinatra'
require 'erb'

configure do
  require 'redis'
  redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redisUri) 
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  num = REDIS.llen "key"
  (num..(num+100)).each do |n|
     REDIS.lpush "key", n
  end
end

get '/' do
   @values = REDIS.lrange "key", 0, -1
   erb :index
end
