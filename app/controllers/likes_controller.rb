class LikesController < ApplicationController

  # GET: /likes
  get "/likes" do
    erb :"/likes/index.html"
  end

  # GET: /likes/new
  get "/likes/new" do
    erb :"/likes/new.html"
  end

  # POST: /likes
  post "/likes" do
    redirect "/likes"
  end

  # GET: /likes/5
  get "/likes/:id" do
    erb :"/likes/show.html"
  end

  # GET: /likes/5/edit
  get "/likes/:id/edit" do
    erb :"/likes/edit.html"
  end

  # PATCH: /likes/5
  patch "/likes/:id" do
    redirect "/likes/:id"
  end

  # DELETE: /likes/5/delete
  delete "/likes/:id/delete" do
    redirect "/likes"
  end
end
