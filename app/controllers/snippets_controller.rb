class SnippetsController < ApplicationController

  # ----- INDEX -----

  get '/snippet-library' do
    if logged_in?
      @snippets = Snippet.all.where("access_level = 'Public'")
      @label_ids = @snippets.collect {|snippet| snippet.label_ids}.uniq.flatten
      @labels = Label.find(@label_ids) # get only labels for public snippets
      @user = false # links in labels navigator should point to public pages
      erb :'/snippets/index', :layout => :labels_layout
    else
      redirect to '/login'
    end
  end

  # ----- CREATE -----

  get '/snippets/new' do
    if logged_in?
      @labels = Label.all
      erb :'/snippets/new'
    else
      redirect to '/login'
    end
  end


  post '/snippets' do
    if !params[:content].empty?
      new_snippet = Snippet.create(name: params[:name], content: params[:content], language: params[:language], access_level: params[:access_level])
      current_user.snippets << new_snippet

      if !params[:labels].empty?
        params[:labels].each do |label|
          label = Label.find_or_create_by(name: label)
          current_user.labels << label
          new_snippet.labels << label
        end
      end

      redirect to "/snippets"
    else
      redirect to "/snippets/new"
    end
  end

  # ----- READ -----

  get "/snippets/:id" do
    if logged_in?
      @snippet = Snippet.find_by(id: params[:id])
      @user = current_user
      erb :"snippets/show"
    else
      redirect to "/login"
    end
  end

  # ----- UPDATE -----

  get "/snippets/:id/edit" do
    @snippet = Snippet.find_by(id: params[:id])
    @labels = Label.all
    if logged_in? && current_user.snippets.include?(@snippet)
      erb :"snippets/edit"
    else
      redirect to "/login"
    end
  end

  patch "/snippets/:id" do
    @snippet = Snippet.find_by(id: params[:id])

    binding.pry
    if !params[:name].empty? && !params[:content].empty?
      @snippet.update(name: params[:name], content: params[:content], language: params[:language], access_level: params[:access_level])
      @user = current_user

      erb :"snippets/show"
    else
      redirect to "/snippets/#{@snippet.id}/edit"
    end
  end

  # ----- DELETE -----

  delete "/snippets/:id/delete" do
    @snippet = Snippet.find_by(id: params[:id])

    if logged_in? && current_user.snippets.include?(@snippet)
      Snippet.find_by(id: params[:id]).destroy
      redirect to "/snippets"
    else
      redirect to "/snippets"
    end
  end
end
