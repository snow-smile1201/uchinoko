class Admin::TagsController < ApplicationController
  def index
    #中間モデルからPostモデルのtag_idカラムを指定してgroupでまとめる,タグの使用回数順に並べ替える。
    @tags = Tag.find(TagRelationship.group(:tag_id).order('count(tag_id) desc').pluck(:tag_id))
  end

  private

  def tag_params
    params.require(:tag).permit(:hashname)
  end
end
