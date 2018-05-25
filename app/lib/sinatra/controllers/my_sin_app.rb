class MySinApp < Sinatra::Base
  get('/styles.css'){ scss :styles }
  set :public_folder, "#{SINATRA_PATH}/public"
  set :views, "#{SINATRA_PATH}/views"
  
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