class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :current_provider, :default_tweet, :overlay_options, :random_avatar, :ivoted_tweets, :badge_updated_text
  
  after_filter :reset_random_avatar

  before_filter :counts, :only => [:index, :show]
  before_filter :top_users, :only => :index
  before_filter :find_user, :only => [:edit, :show]

  LOGIN_NOTICE = "Thank you for logging in!"
  SIGNIN_NOTICE = "Thank you for signing up!"
  AUTHORIZATION_FAILED = "Authorization failed!"
  BADGE_FAILED = "We're sorry, we were unable to update your badge at this time."
  PROFILE_UPDATED = "Your Profile has been updated!"
  PROFILE_FAILED = "We we're unable to update your Profile!"
  TWEET_SENT = "You tweet has been sent!"
  TWEET_FAILED = "We are sorry. Something went wrong. Please try again later."

  private

  def badge_updated_text
    if current_provider.provider_type == "twitter"
      txt = "<b>Awesome! Here's your own 'VOTE_NOTICE' Page.</b> Your new avatar will appear on 'CURRENT_LOGIN' in just a few moments. 
      We will revert your avatar photo 2 days after the election. You can always restore your original at any time.<br/>
      <div style='margin: 10px;'><a href='PLATFORM_PATH' class='button grey'>Hide this and view the page</a></div>"
    else
      txt= "<b>Awesome! Here's your own 'VOTE_NOTICE' Page.</b><br/>
      <a href='DOWNLOAD_BADGE' style='color:#999999'>Download the badge</a> and change your CURRENT_PLATFORM profile pic.
      <a href='PLATFORM_PATH' style='color:#999999'>Share this page</a>.
      <div style='margin: 10px;'><a href='PLATFORM_PATH' class='button grey'>Hide this and view the page</a></div>"
    end
    return txt
  end
  
  def find_user
    @provider = Provider.where(:provider_type =>  params[:provider_type], :uuid=> params[:id]).limit(1).first
    return @user ||= @provider.user if !@provider.nil?
    return false
  end
  
  def current_user
    user = User.find(session[:user_id]) rescue session[:user_id] = nil
    return @current_user ||= user if session[:user_id] && !user.nil?
    return @current_user = false
  end
  
  def current_provider
    p = params[:provider_type] || session[:provider]
    return Provider.where(:provider_type=> p, :user_id => session[:user_id]).limit(1).first 
  end
  
  def default_tweet
    idz = current_user.twitter.uuid
    status = ""
    status = "Check out my new twitter badge and my personal voter page http://www.ivoted2012.org/twitter/#{idz} #iwillvote" if current_user
    status = "I voted! And here's my voter page http://www.ivoted2012.org/twitter/#{idz} #ivoted" if current_user && current_user.voted?
    return status
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
    @counts ||= ActiveRecord::Base.connection.execute("SELECT SUM(followers_count) AS total_followers, SUM(CASE WHEN badge_type='ivoted_badge' THEN 1 ELSE 0 END) AS ivoted_badge_count, SUM(CASE WHEN badge_type='ivoted_banner' THEN 1 ELSE 0 END) AS ivoted_banner_count, SUM(CASE WHEN badge_type='ipledge_badge' THEN 1 ELSE 0 END) AS ipledge_badge_count, SUM(CASE WHEN badge_type='ipledge_banner' THEN 1 ELSE 0 END) AS ipledge_banner_count, SUM(CASE WHEN badge_type='original' THEN 1 ELSE 0 END) AS original_count FROM providers;").first
  end
  
  def top_users
   # @top_users ||= Provider.where("badge_type != 'original' AND followers_count != 0").order("followers_count DESC").limit(8)
    @top_users ||= Provider.order("followers_count DESC").limit(8)
  end
  
  def random_avatar
    return "/assets/original_girl.jpg"
  end
  
  def reset_random_avatar
    session.delete(:random_avatar_id)
  end
  
  def ivoted_tweets
    @client = Twitter::Client.new(:oauth_token =>ENV['TWITTER_ACCESS_TOKEN'],  :oauth_token_secret =>ENV['TWITTER_ACCESS_SECRET'])
    @ivoted_tweets ||=@client.search("#ivoted", :count => 8, :result_type => "recent")
  end
end