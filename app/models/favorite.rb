class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :inform_activity, as: :subject, dependent: :destroy

  validates :user_id, presence: true
  validates :post_id, presence: true
  #1つの記事に対しいいねは1回まに制限のためのバリデーション
  validates :user_id, uniqueness: {scope: :post_id}

  after_create_commit :inform_activities

  private

    def inform_activities
      InformActivity.create(subject: self, user_id: self.post.user.id, action_type: :favorited_the_post)
    end
end
