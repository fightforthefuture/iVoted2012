class PostsController < ApplicationController

  def index
    if !current_user || !current_user.admin
      redirect_to "/twitter", :notice => "You are not Authorized! Please sign-in." 
    else
      @posts = Post.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @posts }
      end
    end
  end

  def create
    if current_user.nil? || params[:post][:user_id].to_i != current_user.id.to_i
      redirect_to "/twitter", :notice => "You are unauthorized for that action. Please sign-in!"
    else
      send_tweet(params[:post][:message])
      @post = Post.new(params[:post])
      if @post.save
        flash[:notice] = TWEET_SENT
        redirect_to user_path(current_user) 
      else
        flash[:notice] = TWEET_FAILED
        redirect_to user_path(current_user)
      end
    end
  end
  
  def send_tweet(message)
    @client = Twitter::Client.new(:oauth_token => current_user.twitter_oauth_token, :oauth_token_secret => current_user.twitter_oauth_token_secret)
    @client.update(message)
  end

end
