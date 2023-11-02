class Post < ApplicationRecord
  belongs_to :user
  belongs_to :child
  belongs_to :genre
  has_many :post_commtents, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relathonships
end
