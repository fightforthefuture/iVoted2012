class TwitterController < ApplicationController

  require 'open-uri'
  require 'net/http'

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
    oauth = OAuth::Consumer.new(ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'],{ :site => "http://twitter.com" })
    session[:request_token] = oauth.get_request_token(:oauth_callback => TWITTER_CALLBACK)
    redirect_to session[:request_token].authorize_url
  end
  
  def create
    token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    @client = Twitter::Client.new(
    :oauth_token => token.token,
    :oauth_token_secret => token.secret
    )
    user = User.find_by_twitter_screen_name(token.params[:screen_name])
    if !user.nil?
      session[:user_id] = user.id
      redirect_to "/twitter/#{screen_name}", :notice => "Signed in!"
    else
      create_user(token, @client)
    end
  end

  def create_user(token, client)
    screen_name = token.params[:screen_name]
    creds = client.verify_credentials
    avatar_url = client.user(screen_name).profile_image_url(:bigger)
    image_file = open avatar_url
    Rails.logger.info avatar_url
    Rails.logger.info image_file.inspect
    user = User.new(
      :twitter_screen_name => screen_name,
      :twitter_id=> creds[:id],
      :twitter_name => creds[:name],
      :twitter_oauth_token => token.token,
      :twitter_oauth_token_secret => token.secret,
      :twitter_active => true,
      :avatar => image_file
      )
    if user.save
      session[:user_id] = user.id
      redirect_to "/twitter/#{screen_name}", :notice => "Signed in!"
    else
      redirect_to root_url, :notice => "Authorization failed!"
    end
  end
  
  def upload_badge
    redirect_to "/twitter", :notice => "You are not authorized to upload a badge. Please sign-in!" if !current_user
    badge = current_user.export_image(params[:badge])
    if badge
      redirect_to "/twitter/#{current_user.login}", :notice => "Your badge has been updated!"
    else
      redirect_to "/twitter/#{current_user.login}", :notice => "We're sorry, we were unable to update your badge at this time."
    end
  end
  
end