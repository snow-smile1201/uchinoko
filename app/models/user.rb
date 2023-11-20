class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  GUEST_USER_EMAIL = "guest@example.com"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :children, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :inform_activities, dependent: :destroy
  has_one_attached :profile_image

  #フォロー・フォロワーのリレーションの記述
  has_many :followings, class_name: "UserRelationship", foreign_key: "following_id", dependent: :destroy
  has_many :followers, class_name: "UserRelationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :followings, source: :follower
  has_many :follower_users, through: :followers, source: :following
  scope :active, -> {where(is_active: true, is_banned: false)}
  scope :inactive, ->  {where(is_active: false, is_banned: true)}
  #引数にnを設定し、n日前の投稿数を取得
  scope :created_days_ago, -> (n) { where(created_at: n.days.ago.all_day) }
  #7日間の投稿数を取得、一週間前のデータから配列に格納
  def self.past_week_count
    (0..6).map { |n| created_days_ago(n).count }.reverse
  end

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def is_active?
    self.is_active == true ? "有効" : "退会済"
  end

  def is_banned?
    self.is_banned == true ? "停止" : "有効"
  end

  def self.search_for(content)
    User.where("name LIKE?","%#{content}%")
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def follow(user_id)
    followings.find_or_create_by(follower_id: user_id)
  end

  def unfollow(user_id)
    followings.find_by(follower_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end

  def unpublish_posts
    self.posts.update_all(is_banned: true)
  end

  def publish_posts
    self.posts.update_all(is_banned: false)
  end
  #TODO:N+1問題
  def total_favorites_count
    total_favorites = 0
    self.posts.each do |post|
      total_favorites += post.favorites.count
    end
    total_favorites
  end
  #TODO:N+1問題
  def total_comments_count
    total_comments = 0
    self.posts.each do |post|
      total_comments += post.post_comments.count
    end
    total_comments
  end

  def banned_posts_count
    self.posts.where(is_banned: true).count
  end

  def banned_comments_count
    self.post_comments.where(is_banned: true).count
  end

  def active_for_authentication?
    super && (is_active == true )
  end
end
