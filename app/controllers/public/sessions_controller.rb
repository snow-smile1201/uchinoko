# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
   before_action :reject_user, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]
  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  #ログイン時devise標準のフラッシュメッセージと競合したため以下のように記述
  def reject_user
    @user = User.find_by(email: params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.is_banned == true)
        flash[:alert] = "このアカウントは利用停止中です。"
        redirect_to new_user_registration_path
      elsif @user.valid_password?(params[:user][:password]) && (@user.is_active == false)
        flash[:alert] = "退会済みです。再度ご登録をしてご利用ください。"
        redirect_to new_user_registration_path
      else
      end
    else
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
