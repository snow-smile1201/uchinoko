class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
      @range = params[:range]
      @content = params[:content]
    if @range == 'User'
      @records = User.search_for(@content).page(params[:page])
    else
      @records = Post.includes(:user, :favorites, :post_comments).search_for(@content).page(params[:page])
    end
  end
end
