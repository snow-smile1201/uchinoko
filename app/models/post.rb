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

  #タグ投稿用メソッド
  def save_tag(sent_tags)
    #@postに紐付いているタグが存在する場合、タグ名を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    #既存タグから、送信されてきたタグを除いたタグをold_tagsとする
    old_tags = current_tags - sent_tags
    #送信されてきたタグから、既存タグを除いたタグをnew_tagsとする
    new_tags = sent_tags - current_tags
    #oldタグは削除
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end
    #newタグは保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end
end
