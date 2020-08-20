class ApplicationController < ActionController::Base

  private

  def redirect_if_logged_in
    return unless logged_in?
    redirect_to user_path
  end

  def redirect_if_logged_out
    return if logged_in?
    redirect_to new_session_path
  end

  def logged_in?
    !session[:user_id].nil?
  end
  helper_method :logged_in?

end
