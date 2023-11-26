class Admin::PostsController < ApplicationController
  def index
    @posts = Post.includes(:user, :favorites, :post_comments).page(params[:page]).per(10)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to edit_admin_post_path(@post), alert: "投稿の管理ステータスを変更しました。"
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :children_id, :genre_id, :is_active, :is_banned, :post_image)
  end

end
