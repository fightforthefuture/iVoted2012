class SessionsController < ApplicationController

  def destroy
    flash[:notice] = "You have signed out!"
    session[:user_id] = nil
    @current_user = false
    redirect_to root_url
  end
end