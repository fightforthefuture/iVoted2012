class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  private
  
  def current_user
    return @current_user ||= User.find(session[:user_id]) if session[:user_id]
    return @current_user = false
  end

end