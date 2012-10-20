class UsersController < ApplicationController

  require 'open-uri'
  require 'net/http'

  before_filter :counts, :only => :index
  before_filter :top_users, :only => :index

  def index
    
  end
  
  def edit
    @user = User.find(params[:id])
    @post = Post.new
    redirect_to users_path if @user.nil? || current_user.nil? || @user != current_user
  end

  def show
    @user = User.find(params[:id])
    @client = Twitter::Client.new(:oauth_token => @user.twitter_oauth_token, :oauth_token_secret => @user.twitter_oauth_token_secret)
    @tweets = @client.user_timeline("tyrauber")
    @post = Post.new
  end
  
  def new
    oauth = OAuth::Consumer.new(ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'],{ :site => "http://twitter.com" })
    session[:request_token] = oauth.get_request_token(:oauth_callback => TWITTER_CALLBACK)
    redirect_to session[:request_token].authorize_url
  end
  
  def create
    session[:badge] = params[:badge] if !params[:badge].nil?
    token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    @client = Twitter::Client.new(
    :oauth_token => token.token,
    :oauth_token_secret => token.secret
    )
    user = User.find_by_twitter_screen_name(token.params[:screen_name])
    if !user.nil?
      flash[:notice] = SIGNIN_NOTICE
      session[:user_id] = user.id
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
      redirect_to edit_user_path(user)
    else
      flash[:notice] = AUTHORIZATION_FAILED
      session[:user_id] = nil
      redirect_to root_url
    end
  end
  
  def update
    @user = User.find(params[:id])
    if current_user.nil? || current_user != @user
      flash[:notice] = AUTHORIZATION_FAILED
      session[:user_id] = nil
      redirect_to root_url
    else   
      if @user.update_attributes(params[:user])
        flash[:notice] = PROFILE_UPDATED
        redirect_to user_path(@user)
      else
        flash[:notice] = @user.errors.full_messages.to_sentence
        redirect_to edit_user_path(@user)
      end
    end
  end
  
  
  def upload_badge
    redirect_to "/twitter", :notice => "You are not authorized to upload a badge. Please sign-in!" if !current_user
    badge = current_user.export_image(params[:badge])
    if badge
      flash[:notice] = BADGE_UPDATED
      redirect_to user_path(current_user)
    else
      flash[:notice] = BADGE_FAILED
      redirect_to user_path(current_user)
    end
  end 
end
