class ProvidersController < ApplicationController
  
  before_filter :show_redirect, :only => [:show]
  before_filter :edit_redirect, :only => [:edit]

  def login
    session[:badge] = params[:badge]
    redirect_to "/auth/#{params[:auth_type]}"
  end
  
  def new
    session[:badge] = params[:badge]
    session[:email] = params[:email] if !params[:email].blank?
    session[:autotweet] = (params[:autotweet] == "true")
    session[:message] = params[:message] if !params[:message].blank?
    Rails.logger.info "#{session[:autotweet]} :: #{session[:message]} "
    redirect_to "/auth/#{params[:auth_type]}"
  end
  
  def voted
    redirect_to root_url if !current_user
    session[:badge]= "ivoted_banner" if !session[:badge].match("sopa")
    current_user.update_attributes(:voted=> true)
    @photo = current_provider.photos.last
    render "photos/new"
  end
  
  def tweet
    @user = User.find(params[:id])
    msg = params[:message]
    url = "/twitter/new?badge=ivoted_banner&autotweet=true&message=#{msg}"
    if (current_provider.nil? || current_provider.provider_type != "twitter")
      redirect_to url
    else
      current_provider.send_tweet(msg) rescue false
      redirect_to :back, :notice => TWEET_SENT
    end
  end
  
  def index
    render "providers/index"
  end
  
  def show
    @post = Post.new
    render "providers/show"
  end

  def edit
    @post = Post.new
    render "providers/edit"
  end
  
  def update
    atts = {:following => (params[:provider][:following] == "1")}
    atts.merge!(:name=> params[:provider][:name]) if !params[:provider][:name].blank?
    sopa = ""; sopa = "/sopa" if params[:badge][:sopa] == "true"
    current_provider.update_attributes(atts)
    if current_user.update_attributes(params[:user])
      flash[:notice] = PROFILE_UPDATED
      redirect_to "/#{current_provider.provider_type}/#{current_provider.uuid}#{sopa}"
    else
      flash[:notice] = current_user.errors.full_messages.to_sentence
      redirect_to :back
    end
  end
  
  def edit_redirect
    redirect_to "/", :notice => AUTHORIZATION_FAILED if (!@user && !current_user) || (current_user != @user)
  end
  
  def show_redirect
    redirect_to "/", :notice => AUTHORIZATION_FAILED if (!@user)
  end

end