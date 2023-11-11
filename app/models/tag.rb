class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :tag_relationships

  def self.search_for(content)
    Tag.where("hashname LIKE?","%#{content}%")
  end
end
