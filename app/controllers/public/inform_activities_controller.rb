class Public::InformActivitiesController < ApplicationController
  def index
    @activities = current_user.inform_activities.order(created_at: :desc).page(params[:page]).per(10)
    @activities.where(is_unread: true).each do |activity|
      activity.update(is_unread: false)
    end
  end

  def destroy
    @activities = current_user.inform_activities.destroy_all
    redirect_to inform_activities_path
  end
end
