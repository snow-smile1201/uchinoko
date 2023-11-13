class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_post_path(@post)
    else
      render :edit
    end
  end
    
  private
  
  def post_params
    params.require(:post).permit(:title, :body, :children_id, :genre_id, :is_active, :is_banned, :post_image)
  end
    
end
