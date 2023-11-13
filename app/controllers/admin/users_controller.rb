class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
#ユーザー凍結・解凍
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #ユーザーを公開停止すると投稿も非公開にする
      if @user.is_banned == true
        @user.unpublish_posts if @user.posts.exists?
      #ユーザーを公開すると投稿も公開になる
      elsif @user.is_banned == false
        @user.publish_posts if @user.posts.exists?
      end
        redirect_to edit_admin_user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :policy, :is_active, :is_banned)
  end
end
