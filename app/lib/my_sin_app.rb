require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'sass'
SINATRA_PATH = "#{Rails.root}/app/lib/sinatra"

%w(helpers controllers).each{|folder|
  Dir["#{SINATRA_PATH}/#{folder}/*.rb"].each {|file| require file }
}