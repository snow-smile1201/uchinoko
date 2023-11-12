class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
