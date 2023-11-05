class Public::PostsController < ApplicationController
  def index
    @genres = Genre.all
    @posts = Post.all
  end

  def new
    @post = Post.new
    @tags = @post.tags.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    #:tag_idにするとエラー？:nameにすると動作する
    @tags = params[:post][:name].split(',')
    if @post.save
      @post.save_tags(@tags)
      redirect_to post_path(@post)
    else
      render :new
    end

  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @tags = @post.tags.pluck(:name).join(',')
  end

  def edit
    @post = Post.find(params[:id])
    @tags = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    #:tag_idにするとエラー？:nameにすると動作する
    @tags = params[:post][:name].split(',')
    if @post.update(post_params)
      @post.update_tags(@tags)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

private

  def post_params
    params.require(:post).permit(:title, :body, :child_id, :genre_id, :is_active, :post_image)
  end
end
