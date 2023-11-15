class Post < ApplicationRecord
  belongs_to :user
  belongs_to :child
  belongs_to :genre
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
  has_one_attached :post_image
  #引数にnを設定し、n日前の投稿数を取得
  scope :created_days_ago, -> (n) { where(created_at: n.days.ago.all_day) }
  #n日間の投稿数を取得、一週間前のデータから配列に格納
  def self.past_week_count
    (0..6).map { |n| created_days_ago(n).count }.reverse
  end

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      post_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content)
    Post.where("title LIKE?","%#{content}%")
  end
  #postのcreateアクション後に投稿のbodyから#をスキャンし、すでに作成済みタグのはfind,新しいタグはタグモデルのhashnameカラムに格納
  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    post.tags = []
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end
#postのupdateアクション前にタグをクリアした上で上記同様の処理を実行
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
