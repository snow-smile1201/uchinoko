class Public::ChildrenController < ApplicationController
  def index
    @child = Child.new
    @children = current_user.children.all
  end

  def create
    @child = Child.new(child_params)
    @child.user_id = current_user.id
    @children = current_user.children.all
    if @child.save
      redirect_to children_path
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
      redirect_to children_path
    else
      render :edit
    end
  end

   private
  def child_params
    params.require(:child).permit(:name, :birthday, :profile_image)
  end
end