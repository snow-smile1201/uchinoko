class PostComment < ApplicationRecord
  after_create_commit :inform_activities
  belongs_to :user
  belongs_to :post
  validates :comment, presence: true

  def name
    user.name
  end
  private

    def inform_activities
      InformActivity.create!(subject: self, user_id: self.post.user.id, action_type: InformActivity.action_types[ :commented_on_the_post ])
    end

    def redirect_path
      post_path(post)
    end
end
