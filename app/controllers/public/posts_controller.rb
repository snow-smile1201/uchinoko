class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_publish_post, only: [:show]
  before_action :check_child_presence, only: [:new]
  before_action :detect_inapporopriate_image, only: [:create, :update]
  after_action :sentiment_analysis_message, only: [:create, :update]

  def index
    @user = current_user
    @genres = Genre.all
    #hashtagは使用頻度が高い順に上位１０件が表示されるようにする。
    @tags = Tag.find(TagRelationship.group(:tag_id).order('count(post_id) desc').limit(10).pluck(:tag_id))
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
    @post.score = Language.get_data(post_params[:body])
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
    @post.score = Language.get_data(post_params[:body])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, alert: "投稿を削除しました。"
  end

  def hashtag
    @user = current_user
    @tag = Tag.find_by(hashname: params[:name])
    @posts = @tag.posts
  end
  
  def pick_up
    @posts = Post.published.positive
  end

private

  def post_params
    params.require(:post).permit(:title, :body, :child_id, :genre_id, :is_active, :is_banned, :post_image, :score)
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

  def detect_inapporopriate_image
    if post_params[:post_image].present?
      result = Vision.image_analysis(post_params[:post_image])
      unless result
        redirect_to request.referer, alert: '不適切な画像を含むため投稿できません'
      end
    end
  end

  def sentiment_analysis_message
    score = @post.score
    if score >= 0.8
      message = "とても明るい内容ですね。たくさんシェアしましょう！"
    elsif 0 <= score && score < 0.8
      message = "これからの成長が楽しみですね。"
    elsif -0.5 <= score && score < 0
      message = "たまにはリフレッシュの時間も作ってくださいね。"
    else
      message = "一人で抱え込みすぎず、誰かに相談してみてくださいね。"
    end
    flash[:notice] = message
  end
end

