class TwitterController < ApplicationController


  def index
    
  end

  def show
    @user = User.find_by_twitter_screen_name(params[:id])
    @client = Twitter::Client.new(:oauth_token => @user.twitter_oauth_token, :oauth_token_secret => @user.twitter_oauth_token_secret)
    @tweets = @client.user_timeline("tyrauber")
    @post = Post.new
    redirect_to "/twitter" if @user.nil?
  end
  
  def new
    Rails.logger.info "Key = #{ENV['TWITTER_CONSUMER_KEY']}."
    Rails.logger.info "Key = #{ENV['TWITTER_CONSUMER_SECRET']}."
    oauth = OAuth::Consumer.new(ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'],{ :site => "http://twitter.com" })
    callback = "http://127.0.0.1:3000/auth/twitter/callback"
    session[:request_token] = oauth.get_request_token(:oauth_callback => callback)
    redirect_to session[:request_token].authorize_url
  end
  
  def create
    token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    @client = Twitter::Client.new(
    :oauth_token => token.token,
    :oauth_token_secret => token.secret
    )
    authorize(token, @client)
  end
  
  def authorize(token, client)
    screen_name = token.params[:screen_name]
    creds = client.verify_credentials
    Rails.logger.info creds.inspect
    user = User.find_by_twitter_screen_name(screen_name) || User.create(:twitter_screen_name => screen_name)
    if user.update_attributes(
      :twitter_id=> creds[:id],
      :twitter_name => creds[:name],
      :twitter_oauth_token => token.token,
      :twitter_oauth_token_secret => token.secret,
      :twitter_active => true
      )
      user.download_image
      session[:user_id] = user.id
      redirect_to "/twitter/#{screen_name}", :notice => "Signed in!"
    else
      redirect_to root_url, :notice => "Authorization failed!"
    end
  end
  
  def upload_badge
    redirect_to "/twitter", :notice => "You are not authorized to upload a badge. Please sign-in!" if !current_user
    badge = current_user.export_image(params[:badge])
    current_user.update_attributes(:twitter_badge_style => params[:badge])
    @client = Twitter::Client.new(:oauth_token => current_user.twitter_oauth_token, :oauth_token_secret => current_user.twitter_oauth_token_secret)
    @client.update_profile_image(File.new(badge))
    redirect_to "/twitter/#{current_user.login}", :notice => "Your badge has been updated!"
  end
  

  
end