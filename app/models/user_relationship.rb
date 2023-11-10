class UserRelationship < ApplicationRecord
  after_create_commit :inform_activities

  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User"

  def name
    following.name
  end

  private

    def inform_activities
      InformActivity.create!(subject: self, user_id: self.follower_id, action_type: InformActivity.action_types[ :followed_you ])
    end

    def redirect_path
      user_path(follower)
    end
end
