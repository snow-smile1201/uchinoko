class Public::SearchesController < ApplicationController
  def search
      @range = params[:range]
      @content = params[:content]
    if @range == 'User'
      #アクティブユーザーのみを検索結果に表示
      @records = User.active.search_for(@content).page(params[:page])
    else
       #公開ステータスが有効の投稿のみを検索結果に表示
      @records = Post.published.search_for(@content).page(params[:page])
    end
  end
  
  def genre_search
    @genre_id = params[:genre_id]
     #公開ステータスが有効の投稿のみを検索結果に表示
    @posts = Post.published.where(genre_id: @genre_id)
  end
end
