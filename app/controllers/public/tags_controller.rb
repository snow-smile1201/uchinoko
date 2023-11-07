class Public::TagsController < ApplicationController
  
  private
  
  def tag_params
    params.require(:tag).permit(:name)
  end
end
