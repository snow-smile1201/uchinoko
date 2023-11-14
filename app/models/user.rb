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

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
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
    followings.create(follower_id: user_id)
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
