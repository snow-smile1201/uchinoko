class Public::ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :detect_inapporopriate_image, only: [:create, :update]

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

  def detect_inapporopriate_image
    if child_params[:profile_image].present?
      result = Vision.image_analysis(child_params[:profile_image])
      unless result
        redirect_to request.referer, alert: '不適切な画像を含むため投稿できません'
      end
    end
  end
end