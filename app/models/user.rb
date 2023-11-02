class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :children, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  #フォロー・フォロワーのリレーションの記述
  has_many :following, class_name: "UserRelationship", foreign_key: "following_id", dependent: :destroy
  has_many :followed, class_name: "UserRelationship", foreign_key: "followed_id", dependent: :destroy
  #following_user:中間テーブルを通してfollowed(user)モデルのフォローされる側を取得
  has_many :following_user, through: :following, source: :followed 
  #follower_user:中間テーブルを通してfollowing(user)モデルのフォローする側を取得
  has_many :follower_user, through: :followed, source: :following
  
    # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end
end
