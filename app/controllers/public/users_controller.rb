class Public::UsersController < ApplicationController
before_action :ensure_collect_user, only: [:edit]
before_action :ensure_active_user, only: [:show]

  def index
    #フォロワーの多い順に有効ステータスのユーザー一覧を表示
    users = User.active.includes(:followers, :posts, :favorites)
    sorted_users = users.sort_by { |user| -user.followers.count }
    @users = Kaminari.paginate_array(sorted_users).page(params[:page]).per(5)
  end

  def show
    @user = User.find(params[:id])
    @children = @user.children
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    #ユーザー本人には全ての投稿を表示、それ以外のユーザーには公開ステータスの投稿のみ表示
    if @user == current_user
      @posts = @user.posts.unbanned.order(created_at: :desc).page(params[:page]).per(10)
    else
      @posts = @user.posts.published.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def followings
    user = User.find(params[:id])
    @users = user.following_users
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_users
  end

  def my_favorites
    favorite_posts_ids = Favorite.where(user_id: current_user.id).pluck(:post_id)
    @posts = Post.published.where(id: favorite_posts_ids).page(params[:page]).per(10)
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_active: false)
    #ユーザーが退会すると投稿は非公開にする
    @user.unpublish_posts
    reset_session
    redirect_to root_path, alert: "退会処理を実行いたしました。"
  end

  def confirm_withdraw
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :policy, :is_active, :profile_image)
  end

  def ensure_collect_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), alert: 'ゲストユーザーはプロフィール編集画面に遷移できません。'
    elsif @user != current_user
      redirect_to user_path(current_user), alert: '他ユーザーのプロフィール編集画面には遷移できません。'
    end
  end

  #退会済・停止済のユーザー詳細ページには遷移しない
  def ensure_active_user
    @user = User.find(params[:id])
    unless @user.is_active == true && (@user.is_banned == false)
      redirect_to user_path(current_user), alert:"お探しのユーザーはすでに退会済みです"
    end
  end
end
