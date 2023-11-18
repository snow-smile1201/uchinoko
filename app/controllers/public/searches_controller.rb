class Public::SearchesController < ApplicationController
  def search
      @range = params[:range]
      @content = params[:content]
    if @range == 'User'
      @records = User.search_for(@content).page(params[:page])
    else
      @records = Post.search_for(@content).page(params[:page])
    end
  end
  
  def genre_search
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id)
  end
end
