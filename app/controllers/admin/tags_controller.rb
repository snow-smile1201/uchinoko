class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    #中間モデルからtag_idカラムを指定してgroupでまとめる,タグの使用回数順に並べ替えて配列に格納。
    @tags = Tag.find(TagRelationship.group(:tag_id).order('count(tag_id) desc').pluck(:tag_id))
  end

  private

  def tag_params
    params.require(:tag).permit(:hashname)
  end
end
