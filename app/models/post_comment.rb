class PostComment < ApplicationRecord
  after_create_commit :inform_activities
  belongs_to :user
  belongs_to :post
  has_one :inform_activity, as: :subject, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 150 }
  validates :user_id, presence: true
  validates :post_id, presence: true

  scope :published, -> {where(is_banned: false)}
  scope :unpublished, ->  {where(is_banned: true)}

  private

    def inform_activities
      InformActivity.create(subject: self, user_id: self.post.user.id, action_type: :commented_on_the_post)
    end
end
