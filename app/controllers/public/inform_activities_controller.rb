class Public::InformActivitiesController < ApplicationController
  def index
    @activities = current_user.inform_activities.order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def is_read
    activity = current_user.inform_activities.find(params[:id])
    unless activity.read?
      activity.update(is_unread: false)
    end
    redirect_to activity.subject.redirect_path
  end
end
