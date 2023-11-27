class Public::TagsController < ApplicationController
  before_action :authenticate_user!

  private

  def tag_params
    params.require(:tag).permit(:hashname)
  end
end
