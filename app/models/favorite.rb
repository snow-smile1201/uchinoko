class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  validates :user_id, presence: true
  validates :post_id, presence: true
  #1つの記事に対しいいねは1回までとする制限のためのバリデーション
  validates :user_id, uniqueness: {scope: :post_id}
  
end
