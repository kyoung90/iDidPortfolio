require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') 
    register Sinatra::Flash
  end

  get "/" do
    flash.now[:danger] = "I'm in danger."
    erb :welcome
  end

end
