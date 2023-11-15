class Admin::HomesController < ApplicationController
  def top
    @users = User.all
    @posts = Post.all
  end
end
