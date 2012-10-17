class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :default_tweet, :overlay_options
  
  private
  
  def current_user
    return @current_user ||= User.find(session[:user_id]) if session[:user_id]
    return @current_user = false
  end
  
  def default_tweet
     "#iVoted2012, I just voted and got my own iVoted2012.org profile page. Join me and pledge your vote."
  end

  def overlay_options
     [
       {:name => 'full_badge', :title=> "Full Image Badge", :description=> "Replace your avatar with a full iVoted2012.org Badge"},
       {:name => 'banner_badge', :title=> "Banner Badge Overlay", :description=> "An overlay badge on of your current twitter avatar."},
       {:name => 'original', :title=> "No Badge", :description=> "Your original twitter avatar."}
      ]
  end

end