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

  # GET: /projects/5
  get "/projects/:user/:project_title_slug" do
    user = User.find_by_slug(params[:user])
    if user
        @project = Project.find_by_slug_and_user_id(params[:project_title_slug], user.id)
        if @project 
          erb :"/projects/show.html"
        else 
          redirect "/projects"
        end 
    end 
  end

  # GET: /projects/5/edit
  get "/projects/:id/edit" do
    erb :"/projects/edit.html"
  end

  # PATCH: /projects/5
  patch "/projects/:id" do
    redirect "/projects/:id"
  end

  # DELETE: /projects/5/delete
  delete "/projects/:id/delete" do
    redirect "/projects"
  end
end
