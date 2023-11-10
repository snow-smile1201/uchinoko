class InformActivity < ApplicationRecord
  belongs_to :subject, polymorphic: true
  
  enum action_type: { favorited_the_post: 0, commented_on_the_post: 1, followed_you: 2 }
end
