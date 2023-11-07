class Public::UsersController < ApplicationController
  def index
    @user = current_user
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @children = @user.children
    @following_users = @user.following_users
    @follower_users = @user.follower_users
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
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
  end

  def confirm_withdraw
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :is_active, :profile_image)
  end
end
