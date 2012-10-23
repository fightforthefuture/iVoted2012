class UsersController < ApplicationController

  require 'open-uri'
  require 'net/http'

  before_filter :counts, :only => :index
  before_filter :top_users, :only => :index
  before_filter :authorize, :only => [:pick_badge, :upload_badge, :update, :edit]
  
  def index
    
  end
  
  def edit
    @user = User.find(params[:id])
    @post = Post.new
    redirect_to users_path if @user.nil? || current_user.nil? || @user != current_user
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url if @user.nil?
    # @client = Twitter::Client.new(:oauth_token => @user.twitter_oauth_token, :oauth_token_secret => @user.twitter_oauth_token_secret)
    # @tweets = @client.user_timeline("tyrauber")
    @post = Post.new
  end
  
  def new
    session[:badge] = params[:badge] if !params[:badge].nil?
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
      flash[:notice] = LOGIN_NOTICE
      session[:user_id] = user.id
      user.update_tokens(token)
      redirect_to edit_user_path(user)
    else
      create_user(token, @client)
    end
  end

  def create_user(token, client)
    screen_name = token.params[:screen_name]
    creds = client.verify_credentials
    avatar_url = client.user(screen_name).profile_image_url(:bigger)
    image_file = open User.read_remote_image(screen_name, avatar_url)
    user = User.new(
      :twitter_screen_name => screen_name,
      :twitter_id=> creds[:id],
      :twitter_name => creds[:name],
      :twitter_oauth_token => token.token,
      :twitter_oauth_token_secret => token.secret,
      :twitter_active => true,
      :twitter_followers_count => creds[:followers_count],
      :twitter_listed_count => creds[:listed_count],
      :twitter_friends_count => creds[:friends_count],
      :twitter_favourites_count => creds[:favourites_count],
      :avatar => image_file
      )
    if user.save
      flash[:notice] = SIGNIN_NOTICE
      session[:user_id] = user.id
      redirect_to pick_badge_users_path
    else
      flash[:notice] = AUTHORIZATION_FAILED
      session[:user_id] = nil
      redirect_to root_url
    end
  end
  
  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = PROFILE_UPDATED
      redirect_to user_path(current_user)
    else
      flash[:notice] = current_user.errors.full_messages.to_sentence
      redirect_to edit_user_path(current_user)
    end
  end
  
  def pick_badge
    @user = current_user
  end
  
  def upload_badge
    badge = current_user.export_image(params[:badge])
    if badge
      session[:badge] = params[:badge]
      flash[:notice] = BADGE_UPDATED
      redirect_to edit_user_path(current_user)
    else
      flash[:notice] = BADGE_FAILED
      redirect_to pick_badge_users_path
    end
  end 
  
  def download_badge
    file = User.read_remote_image(current_user.login, current_user.badge.url)
    send_file file, :type => 'image/png', :disposition => 'attachment'
  end
  
  def authorize
    Rails.logger.info "Authorize"
    if !current_user
      flash[:notice] = AUTHORIZATION_FAILED
      session[:user_id] = nil
      Rails.logger.info flash[:notice] 
      redirect_to root_url
    end
  end
end
