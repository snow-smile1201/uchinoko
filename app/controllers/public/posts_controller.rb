class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_publish_post, only: [:show]
  before_action :check_child_presence, only: [:new]

  def index
    @user = current_user
    @genres = Genre.all
    #公開ステータスが有効、かつユーザーとフォローしているユーザーの投稿を取得
    following_users_ids = current_user.following_users.pluck(:id)
    posts = Post.published.includes(:user, :post_comments, :favorites).where(user_id: [current_user.id, *following_users_ids])
    @posts = posts.order(created_at: :desc).page(params[:page]).per(6)
  end

  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @user = current_user
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_path(@post), notice: '投稿しました'
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
    @user = current_user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿を更新しました'
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

  def ensure_publish_post
    @post = Post.find(params[:id])
    #投稿者本人以外は非公開設定の投稿を見ることができない。
    unless @post.is_banned == true
      if @post.user != current_user && @post.is_active == false
        redirect_to posts_path, alert: "この投稿は非公開です"
      end
    else
      #管理者により公開停止の投稿は投稿者本人も見ることができない
      redirect_to posts_path, alert: "この投稿は公開停止中です"
    end
  end

  def check_child_presence
    user = current_user
    if user.children.empty?
      redirect_to children_path, notice: "投稿前にこちらからお子さまの情報を登録してください"
    end
  end
end
