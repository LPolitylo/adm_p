require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'sass'

%w(helpers controllers).each{|folder|
  Dir["#{Rails.root}/app/lib/sinatra/#{folder}/*.rb"].each {|file| require file }
}