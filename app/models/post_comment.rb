class PostComment < ApplicationRecord
  after_create_commit :inform_activities
  belongs_to :user
  belongs_to :post
  has_one :inform_activity, as: :subject, dependent: :destroy
  validates :comment, presence: true

  private

    def inform_activities
      InformActivity.create(subject: self, user: self.post.user, action_type: :commented_on_the_post)
    end
end
