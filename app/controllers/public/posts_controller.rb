class Public::PostsController < ApplicationController
  def index
    @genres = Genre.all
    #ユーザーとフォローしているユーザーの投稿を取得
    following_users_ids = current_user.following_ids
    posts = Post.where(user_id: [current_user.id, *following_users_ids])
    @posts = posts.sort_by(&:created_at).reverse
  end

  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @user = current_user
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @user = current_user
    @post = Post.find(params[:id])

  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
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

  def hashtag
    @user = current_user
    @tag = Tag.find_by(hashname: params[:name])
    @posts = @tag.posts
  end

private

  def post_params
    params.require(:post).permit(:title, :body, :child_id, :genre_id, :is_active, :is_banned, :post_image)
  end
end
