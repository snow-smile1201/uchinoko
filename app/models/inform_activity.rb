class InformActivity < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :subject, polymorphic: true, optional: true

  enum action_type: { favorited_the_post: 0, commented_on_the_post: 1, followed_you: 2 }

end
