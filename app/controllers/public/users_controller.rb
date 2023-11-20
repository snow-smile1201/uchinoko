class Public::UsersController < ApplicationController
  def index
    #フォロワーの多い順にユーザー一覧を表示
    users = User.active.includes(:followers).all
    @users = users.sort_by { |user| -user.followers.count }
  end

  def show
    @user = User.find(params[:id])
    @children = @user.children
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    if @user == current_user
      @posts = @user.posts
    else
      @posts = @user.posts.published
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

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to top_path
  end

  def confirm_withdraw
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :policy, :is_active, :profile_image)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面に遷移できません。'
    end
  end
end
