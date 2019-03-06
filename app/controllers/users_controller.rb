class UsersController < ApplicationController


  get "/login" do 
    if !session.key?(:user_id)
      erb :"users/login.html"
    else 
      flash.now[:message] = "Can't login if you already logged in."
      redirect "/welcome"
    end 
  end 

  post "/login" do 
    if !session.key?(:user_id)
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash.now[:info] = "Successfully logged in."
        redirect "/users/#{user.slug}"
      else
        flash.now[:message] = "Unable to log you in. Incorrect username or password."
        redirect "/login"
      end
    else 
      flash.now[:message] = "Can't login if you already logged in."
      redirect "/welcome"
    end 
  end 

  get "/signup" do 
    if !session.key?(:user_id)
      erb :"/users/new.html"
    else 
      flash.now[:message] = "Can't sign up if you already signed up."
      redirect "/welcome"
    end 
      
  end

  post "/signup" do  
    if !session.key?(:user_id)
      if params[:username] != "" && params[:password] != "" && params[:email] != ""
        if User.find_by(username: params[:username]) && User.find_by(email: params[:email])
          flash.now[:message] = "A user with that email or username already exists."
        else 
          user = User.create(username: params[:username], email: params[:email], password: params[:password])
          flash.now[:message] = "Successfully signed up."
          session[:user_id] = user.id
        end 
          redirect "/projects"
      else
        flash.now[:message] = "Incorrect parameters"
        redirect "/signup"
      end
    else 
      flash.now[:message] = "Can't signup if you already signed in."
      redirect "/projects"
    end
  end 

  get "/users/:slug" do 
    @user = User.find_by_slug(params[:slug])
    if @user 
      erb :"users/show.html"
    else 
      redirect "/welcome"
    end 
  end

  get "/logout" do 
    if !session.key?(:user_id)
      redirect "/"
    else 
      session.clear
      flash.now[:info] = "Successfully logged out"
      redirect "/login"
    end 
  end 

end
