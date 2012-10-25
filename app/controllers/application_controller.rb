class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :default_tweet, :overlay_options, :random_avatar
  
  after_filter :reset_random_avatar

  LOGIN_NOTICE = "Thank you for logging in!"
  SIGNIN_NOTICE = "Thank you for signing up!"
  AUTHORIZATION_FAILED = "Authorization failed!"
  BADGE_FAILED = "We're sorry, we were unable to update your badge at this time."
  PROFILE_UPDATED = "Your Profile has been updated!"
  PROFILE_FAILED = "We we're unable to update your Profile!"
  TWEET_SENT = "You tweet has been sent!"
  TWEET_FAILED = "We are sorry. Something went wrong. Please try again later."
  
  BADGE_UPDATED = "<b>Awesome! Here's your own 'VOTE_NOTICE' Page.</b> Your new avatar will appear on 'CURRENT_LOGIN' in just a few moments. 
  We will revert your avatar photo 2 days after the election. You can always restore your original at any time.<br/>
  <div style='margin: 10px;'><a href='/users/CURRENT_ID' class='button grey'>Hide this and view the page</a></div>"
  
  
  private
  
  def current_user
    user = User.find(session[:user_id]) rescue session[:user_id] = nil
    return @current_user ||= user if session[:user_id] && !user.nil?
    return @current_user = false
  end
  
  def default_tweet
    status = "pledged to vote"
    status = "voted" if current_user && current_user.voted?
    idz = session[:user_id    

    return "I voted! And here's my voter page http://www.ivoted2012.org/users/#{idz} #ivoted"
  end

  def overlay_options
     [
       {:name => 'ivoted_badge', :title=> "I Voted Badge", :description=> "Replace your avatar with a full I Voted Badge"},
       {:name => 'ivoted_banner', :title=> "I Voted Banner Overlay", :description=> "An I Voted overlay badge on of your current twitter avatar."},
       {:name => 'ipledge_badge', :title=> "I Pledge Badge", :description=> "Replace your avatar with a full I Plede Badge"},
       {:name => 'ipledge_banner', :title=> "I Pledge Banner Overlay", :description=> "An I Pledge overlay badge on of your current twitter avatar."},
       {:name => 'original', :title=> "No Badge", :description=> "Your original twitter avatar."}
      ]
  end
  
  def counts
    @counts ||= ActiveRecord::Base.connection.execute("SELECT SUM(twitter_followers_count) AS total_followers, SUM(CASE WHEN twitter_badge_style='ivoted_badge' THEN 1 ELSE 0 END) AS ivoted_badge_count, SUM(CASE WHEN twitter_badge_style='ivoted_banner' THEN 1 ELSE 0 END) AS ivoted_banner_count, SUM(CASE WHEN twitter_badge_style='ipledge_badge' THEN 1 ELSE 0 END) AS ipledge_badge_count, SUM(CASE WHEN twitter_badge_style='ipledge_banner' THEN 1 ELSE 0 END) AS ipledge_banner_count, SUM(CASE WHEN twitter_badge_style='original' THEN 1 ELSE 0 END) AS original_count FROM users;").first
  end
  
  def top_users
    @top_users = User.where("twitter_badge_style != 'original'").order("twitter_followers_count DESC").limit(4)
  end
  
  def random_avatar
    session[:random_avatar_id] ||= rand(User.count)
    return "/assets/example_badge.jpg" if session[:random_avatar_id].to_i <= 0
    return rand_record = User.first(:conditions => [ "id >= ?", session[:random_avatar_id] ]).avatar.url
  end
  
  def reset_random_avatar
    session.delete(:random_avatar_id)
  end
end