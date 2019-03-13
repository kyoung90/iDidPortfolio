class ProjectsController < ApplicationController

  # GET: /projects
  get "/projects" do
    @projects = Project.all
    erb :"/projects/index.html"
  end

  # GET: /projects/new
  get "/projects/new" do
    if logged_in?
        erb :"/projects/new.html"
    else 
        flash[:danger] = "Can't create a project unless you are logged in."
        erb :"/login"
    end 
  end

  # POST: /projects
  post "/projects" do
    if logged_in?
      if params[:title] != "" && params[:imageLink0] != ""
        project = Project.create(title: params[:title], image_link0: params[:imageLink0])
        project.user_id = current_user.id
        if params[:description] != ""
          project.description = params[:description]
        end
        if params[:downloadLink] != ""
          project.download_link = params[:downloadLink]
        end
        if params[:imageLink1] != ""
          project.image_link1 = params[:imageLink1]
        end
        if params[:imageLink2] != ""
          project.image_link2 = params[:imageLink2]
        end
        if params[:imageLink3] != ""
          project.image_link3 = params[:imageLink3]
        end
        if params[:imageLink4] != ""
          project.image_link4 = params[:imageLink4]
        end
        project.view_count = 0
        project.save
        flash[:success] = "Successfully created a project."
        redirect "/projects"
      else 
        flash[:danger] = "Incorrect parameters."
        redirect "/projects/new"
      end 
    else 
      flash[:danger] = "Can't create a project unless you are logged in."
      redirect "/login"
    end 
  end

  post "/projects/:project_title_slug/like" do
    if current_user
      @project = Project.find_by_slug_and_user_id(params[:project_title_slug], current_user.id)
      if @project 
        Like.create(user_id: current_user.id, project_id: @project.id)
        redirect "/projects/#{@project.user.slug}/#{@project.slug}"
      else   
        flash[:danger] = "That project was not found."
        redirect "/projects"
      end 
    else 
      flash[:danger] = "Must be logged in to like a project."
      redirect "/projects"
    end 
  end 

  post "/projects/:project_title_slug/unlike" do
    if current_user
      @project = Project.find_by_slug_and_user_id(params[:project_title_slug], current_user.id)
      if @project 
        like = Like.find_by(user_id: current_user.id, project_id: @project.id)
        if like 
          like.delete
          redirect "/projects/#{@project.user.slug}/#{@project.slug}"
        else 
          flash[:danger] = "You can't unlike something you haven't liked."
          redirect "/projects/#{@project.user.slug}/#{@project.slug}"
        end 
      else   
        flash[:danger] = "That project was not found."
        redirect "/projects"
      end 
    else 
      flash[:danger] = "Must be logged in to unlike a project."
      redirect "/projects"
    end 
  end 

  get "/projects/:slug/:project_title_slug" do
    user = User.find_by_slug(params[:slug])
    if user
        @project = Project.find_by_slug_and_user_id(params[:project_title_slug], user.id)
        if @project 
          @project.view_count += 1
          @project.save
          erb :"/projects/show.html"
        else 
          flash[:danger] = "That project was not found."
          redirect "/projects"
        end 
    else
      flash[:danger] = "A user with that username was not found."
      redirect "/projects"
    end 
  end

  get "/projects/:slug/:project_title_slug/edit" do
    @user = User.find_by_slug(params[:slug])
    if @user
        @project = Project.find_by_slug_and_user_id(params[:project_title_slug], @user.id)
        if @project 
          erb :"/projects/edit.html"
        else 
          flash[:danger] = "That project was not found."
          redirect "/users/#{@user.slug}"
        end 
    else
      flash[:danger] = "A user with that username was not found."
      redirect "/projects"
    end
  end

  patch "/projects/:slug/:project_title_slug" do
    @user = User.find_by_slug(params[:slug])
    if @user
        @project = Project.find_by_slug_and_user_id(params[:project_title_slug], @user.id)
        if @project 
          @project.title = params[:title]
          @project.description = params[:description]
          @project.download_link = params[:downloadLink]
          @project.image_link0 = params[:imageLink0]
          @project.image_link1 = params[:imageLink1]
          @project.image_link2 = params[:imageLink2]
          @project.image_link3 = params[:imageLink3]
          @project.image_link4 = params[:imageLink4]
          @project.save 
          flash[:success] = "Edited successfully."
          redirect "/projects/#{params[:slug]}/#{params[:project_title_slug]}"
        else 
          flash[:danger] = "That project was not found."
          redirect "/projects"
        end 
    else
      flash[:danger] = "A user with that username was not found."
      redirect "/projects"
    end
  end

  delete  "/projects/:slug/:project_title_slug" do 
    @user = User.find_by_slug(params[:slug])
    if @user && @user == current_user 
      @project = Project.find_by_slug_and_user_id(params[:project_title_slug], @user.id)
      if @project
        @project.delete
        redirect "/users/#{@user.slug}"
      else 
        flash[:danger] = "Project was not found."
        redirect "/users/#{@user.slug}"
      end
    else 
      flash[:danger] = "A user with that username was not found or you do not have permissions to delete that user."
      redirect "/projects"
    end 
  end
end
