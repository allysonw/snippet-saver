class ApplicationController < Sinatra::Base
  register Sinatra::Flash
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "snippet_manager_secret"
  end

  get '/' do
    erb :index
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find_by(session[:user_id])
  end
end
