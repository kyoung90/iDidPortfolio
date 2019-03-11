class UsersController < ApplicationController


  get "/login" do 
    if !session.key?(:user_id)
      erb :"users/login.html"
    else 
      flash[:danger] = "Can't login if you already logged in."
      redirect "/projects"
    end 
  end 

  post "/login" do 
    if !session.key?(:user_id)
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Successfully logged in."
        redirect "/users/#{user.slug}"
      else
        flash[:danger] = "Unable to log you in. Incorrect username or password."
        redirect "/login"
      end
    else 
      flash[:danger] = "Can't login if you already logged in."
      redirect "/projects"
    end 
  end 

  get "/signup" do 
    if !session.key?(:user_id)
      erb :"/users/new.html"
    else 
      flash[:danger] = "Can't sign up if you already signed up."
      redirect "/projects"
    end 
      
  end

  post "/signup" do  
    if !session.key?(:user_id)
      if params[:username] != "" && params[:password] != "" && params[:email] != ""
        if User.find_by(username: params[:username]) && User.find_by(email: params[:email])
          flash[:danger] = "A user with that email or username already exists."
        else 
          user = User.create(username: params[:username], email: params[:email], password: params[:password])
          flash[:success] = "Successfully signed up."
          session[:user_id] = user.id
        end 
          redirect "/projects"
      else
        flash[:danger] = "Incorrect parameters"
        redirect "/signup"
      end
    else 
      flash[:danger] = "Can't signup if you already signed in."
      redirect "/projects"
    end
  end 

  get "/users/:slug/edit" do 
    @user = User.find_by_slug(params[:slug])
    if @user && current_user == @user
      erb :"users/edit.html"
    else 
      flash[:danger] = "Can't edit someone else's account."
      redirect "/projects"
    end 
  end

  patch "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    if @user && current_user == @user
      @user.username = params[:username]
      @user.email = params[:email]
      @user.profile_pic_link = params[:profilePicLink]
      @user.short_bio = params[:shortBio]
      @user.save
      flash[:success] = "Edit successful."
      redirect "/users/#{params[:slug]}"
    else
      flash[:danger] = "Can't edit someone else's account."
      redirect "/projects"
    end 
  end 

  delete  "/users/:slug" do 
    @user = User.find_by_slug(params[:slug])
    if @user && @user == current_user 
      @user.projects.each do |project|
        project.delete
      end 
      @user.delete
      flash[:success] = "Sucessfully deleted the user and all his projects."
      redirect "/logout"
    else 
      flash[:danger] = "Can't delete someone else's account."
      redirect "/projects"
    end 
  end

  get "/users/:slug" do 
    @user = User.find_by_slug(params[:slug])
    if @user 
      erb :"users/show.html"
    else 
      flash[:danger] = "User not found"
      redirect "/projects"
    end 
  end

  get "/logout" do 
    if !session.key?(:user_id)
      flash[:danger] = "Can't logout if you aren't logged in."
      redirect "/"
    else 
      session.clear
      flash[:success] = "Successfully logged out"
      redirect "/login"
    end 
  end 

end
