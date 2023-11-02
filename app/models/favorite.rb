class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  #1つの記事に対しいいねは1回までとする制限のためのバリデーション
  validates :user_id, uniqueness: {scope: :post_id}
end
