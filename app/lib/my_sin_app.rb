require 'sinatra/base'
require 'slim'
require 'sass'

class MySinApp < Sinatra::Base
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


  get '/logout' do
    session.clear
    redirect to('/login')
  end

  get '/' do
    slim :home
  end

  get '/about' do
    @title = "All About This Website"
    slim :about
  end

  get '/contact' do
    slim :contact
  end

  not_found do
    slim :not_found
  end

  get '/fake-error' do
    status 500
    "There’s nothing wrong, really :P"
  end
end

module SongHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.where(params[:id]).take!
  end

  def create_song
    @song = Song.new(params[:song]).save!
  end
end


class SongController < Sinatra::Base
  enable :method_override
  register Sinatra::Flash  
  
  get('/styles.css'){ scss :styles }
  set :public_folder, "#{Rails.root}/app/assets/sinatra/public"
  set :views, "#{Rails.root}/app/views/sinatra/views"

  helpers SongHelpers 

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
    halt(401,'Not Authorized') unless session[:admin]
    @song = Song.new
    slim :new_song
  end

  get '/:id' do 
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