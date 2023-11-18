class UserRelationship < ApplicationRecord
  after_create_commit :inform_activities

  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User"
  has_one :inform_activity, as: :subject, dependent: :destroy

  private

  def inform_activities
    InformActivity.create(subject: self, user_id: self.follower.id, action_type: :followed_you)
  end
end
