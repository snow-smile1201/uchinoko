class Child < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_one_attached :profile_image

  validates :name, presence: true
  validates :birthday, presence: true

  def total_favorites_count
    total_favorites = 0
    self.posts.each do |post|
      total_favorites += post.favorites.count
    end
    total_favorites
  end

  def total_comments_count
    total_comments = 0
    self.posts.each do |post|
      total_comments += post.post_comments.count
    end
    total_comments
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
     file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
