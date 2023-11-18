module Public::InformActivitiesHelper
  def transition_path(activity)
    case activity.action_type.to_sym
    when :favorited_the_post
      post_path(activity.subject.post)
    when :commented_on_the_post
      post_path(activity.subject.post, anchor: "comment-#{activity.subject.id}")
    when :followed_you
      user_path(activity.subject.follower)
    end
  end
end
