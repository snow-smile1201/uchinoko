class Post < ApplicationRecord
  belongs_to :user
  belongs_to :child
  belongs_to :genre
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships

  has_one_attached :post_image

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      post_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  #ユーザーが当該投稿をいいねしているかの判定メソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #ハッシュタグ投稿用メソッド
  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    post.tags = []
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end

  before_update do
    post = Post.find_by(id: self.id)
    post.tags.clear
    hashtags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end

end
