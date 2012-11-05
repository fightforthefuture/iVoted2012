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
    if current_provider.nil?
      redirect_to "/twitter", :notice => "You are unauthorized for that action. Please sign-in!"
    else
      send_tweet(params)
      @post = Post.new(params[:post])
      if @post.save
        flash[:notice] = TWEET_SENT
        redirect_to :back
      else
        flash[:notice] = TWEET_FAILED
        redirect_to :back
      end
    end
  end
  
  def send_tweet(params)
    provider = Provider.where(:user_id => params[:post][:user_id], :uuid => params[:post][:screen_name], :provider_type => params[:post][:platform]).limit(1).first
    @client = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret)
    @client.update(params[:post][:message])
  end

end
