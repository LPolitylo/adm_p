require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'sass'

module SongHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.where(id: params[:id]).take!
  end

  def create_song
    @song = Song.create(params[:song])
  end
end

module AuthHelpers
  def authorized?
    env["warden"] && env["warden"].authenticated?
  end

  def protected!
    halt 401,slim(:unauthorized) unless authorized?
  end

  def log_out!
    env["warden"] && env["warden"].logout
  end
end

class MySinApp < Sinatra::Base
  helpers AuthHelpers

  before do
    set_title
  end

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end

  def set_title
    @title ||= "Songs By Sinatra"
  end  

  get('/styles.css'){ scss :styles }
  set :public_folder, "#{Rails.root}/app/assets/sinatra/public"
  set :views, "#{Rails.root}/app/views/sinatra/views"

  get '/' do
    slim :home
  end

  get '/about' do
    @title = "All About This Website"
    slim :about
  end

  get '/logout' do
    log_out!
    redirect to('/')
  end

  not_found do
    slim :not_found
  end

  get '/fake-error' do
    status 500
    "There’s nothing wrong, really :P"
  end
end


class SongController < Sinatra::Base
  enable :method_override
  register Sinatra::Flash

  get('/styles.css'){ scss :styles }
  set :public_folder, "#{Rails.root}/app/assets/sinatra/public"
  set :views, "#{Rails.root}/app/views/sinatra/views"

  helpers SongHelpers, AuthHelpers

  before do
    set_title
  end

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end

  def set_title
    @title ||= "Songs By Sinatra"
  end

  get '/' do
    find_songs
    slim :songs
  end

  get '/new' do
    protected!
    @song = Song.new
    slim :new_song
  end

  get '/:id' do 
    protected!
    @song = find_song
    slim :show_song
  end

  get '/:id/edit' do
    protected!
    @song = find_song
    slim :edit_song
  end

  post '/' do
    protected!
    flash[:notice] = "Song successfully added" if create_song
    redirect to("/#{@song.id}")
  end

  put '/:id' do
    song = find_song
    if song.update(params[:song])
      flash[:notice] = "Song successfully updated"
    end
    redirect to("/#{song.id}")
  end

  delete '/:id' do
    protected!
    if find_song.destroy
      flash[:notice] = "Song deleted"
    end
    redirect to('/')
  end
end