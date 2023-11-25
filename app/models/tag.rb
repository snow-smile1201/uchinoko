class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :tag_relationships

  validates :name, presence: true
end
