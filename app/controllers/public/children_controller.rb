class Public::ChildrenController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @child = Child.new
    @children = current_user.children
  end

  def create
    @child = Child.new(child_params)
    @child.user_id = current_user.id
    @children = current_user.children
    if @child.save
      redirect_to user_path(@child.user)
    else
      render :index
    end
  end

  def edit
    @child = Child.find(params[:id])
  end

  def update
    @child = Child.find(params[:id])
    if @child.update(child_params)
      redirect_to user_path(@child.user)
    else
      render :edit
    end
  end

   private
  def child_params
    params.require(:child).permit(:name, :birthday, :profile_image, :user_id)
  end
end