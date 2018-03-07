class SnippetsController < ApplicationController

  # ----- INDEX -----

  get '/snippet-library' do
    if logged_in?
      @snippets = Snippet.all.where("access_level = 'Public'")
      erb :'/snippets/index'
    else
      redirect to '/login'
    end
  end

  # ----- CREATE -----

  get '/snippets/new' do
    if logged_in?
      erb :'/snippets/new'
    else
      redirect to '/login'
    end
  end


  post '/snippets' do
    if !params[:content].empty?
      current_user.snippets.create(params)
      redirect to "/snippets"
    else
      flash[:warning] = "Please fill in all fields"
      redirect to "/snippets/new"
    end
  end

  # ----- READ -----

  get "/snippets/:id" do
  @snippet = Snippet.find_by(id: params[:id])

    if logged_in?
      erb :"snippets/show"
    else
      redirect to "/login"
    end
  end

  # ----- UPDATE -----



end
