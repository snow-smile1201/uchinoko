class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:posts, :post_comments).page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
    @posts = @user.posts
  end
#ユーザー凍結・解凍
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #ユーザーを公開停止すると投稿も全て公開停止にする
      if @user.is_banned == true
        @user.ban_posts if @user.posts.exists?
      #ユーザーを有効化すると投稿も有効になる
      elsif @user.is_banned == false
        @user.republish_posts if @user.posts.exists?
      end
        redirect_to edit_admin_user_path(@user), alert: "ユーザーの管理ステータスを変更しました。"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :policy, :is_active, :is_banned)
  end
end
