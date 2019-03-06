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
        project.save
        redirect "/projects"
      else 
        redirect "/projects/new"
      end 
    else 
      redirect "/login"
    end 
  end

  get "/projects/:slug/:project_title_slug" do
    user = User.find_by_slug(params[:slug])
    if user
        @project = Project.find_by_slug_and_user_id(params[:project_title_slug], user.id)
        if @project 
          erb :"/projects/show.html"
        else 
          redirect "/projects"
        end 
    end 
  end

  get "/projects/:slug/:project_title_slug/edit" do
    @user = User.find_by_slug(params[:slug])
    if @user
        @project = Project.find_by_slug_and_user_id(params[:project_title_slug], @user.id)
        if @project 
          erb :"/projects/edit.html"
        else 
          redirect "/users/#{@user.slug}"
        end 
    else
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
          redirect "/projects/#{params[:slug]}/#{params[:project_title_slug]}"
        else 
          redirect "/projects"
        end 
    else
      redirect "/projects"
    end
  end

  delete  "/projects/:slug/:project_title_slug" do 
    @user = User.find_by_slug(params[:slug])
    if @user && @user == current_user 
      @project = Project.find_by_slug_and_user_id(params[:project_title_slug], @user.id)
      if @project
        @project.delete
      end
      redirect "/users/#{@user.slug}"
    else 
      redirect "/projects"
    end 
  end
end
