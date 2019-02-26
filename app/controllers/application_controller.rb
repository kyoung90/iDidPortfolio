require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') 
  end

  get "/" do
    erb :welcome
  end

end
user_id int fK >- User.id
title string
description string
date_created datetime
download_link string
view_count int
image_link0 string
image_link1 string
image_link2 string
image_link3 string
image_link4 string