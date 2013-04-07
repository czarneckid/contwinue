class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def authorization_denied
    flash[:error] = "Access denied."
    redirect_to root_path and return
  end

  def require_logged_in_user
    authorization_denied unless current_user
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
