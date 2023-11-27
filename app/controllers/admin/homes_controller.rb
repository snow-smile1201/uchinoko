class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = User.all
    @posts = Post.all
  end
end
