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
      item_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  #ユーザーが当該投稿をいいねしているかの判定メソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #タグ投稿用メソッド
  def save_tags(tags)
    tags.each do |new_tags|
      self.tags.find_by(name: new_tags) || self.tags.create(name: new_tags)
    end
  end

  def update_tags(latest_tags)
    #既存のタグがない場合は追加のみ行う
    if self.tags.empty?
      latest_tags.each do |latest_tag|
        self.tags.find_by(name: latest_tag) || self.tags.create(name: latest_tag)
      end
    elsif latest_tags.empty?
      # 更新対象のタグが空の場合、既存のタグを削除
      self.tags.each do |tag|
        self.tags.delete(tag)
      end
    else
      #既存のタグ名を取得しcurrentタグに代入
      current_tags = self.tags.pluck(:name)
      #既存のタグ名から、今回新規に作成されたタグ差し引いた残りをoldタグに代入
      old_tags = current_tags - latest_tags
      #新規作成したタグから現状保存されているタグを差し引いた残りをnewタグに代入
      new_tags = latest_tags - current_tags

      # 既存タグから名前が一致するタグを取り出してtagに代入し、削除
      old_tags.each do |old_tag|
        tag = self.tags.find_by(name: old_tag)
        self.tags.destroy(tag) if tag.present?
      end
      #新しいタグを追加
      new_tags.each do |new_tag|
        self.tags.find_by(name: new_tag) || self.tags.create(name: new_tag)
      end
    end
  end
end
