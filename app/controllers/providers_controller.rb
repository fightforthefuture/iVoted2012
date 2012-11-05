class ProvidersController < ApplicationController
  
  before_filter :redirect, :only => [:edit]

  def login
    session[:badge] = params[:badge]
    redirect_to "/auth/#{params[:auth_type]}"
  end
  
  def new
    session[:badge] = params[:badge]
    redirect_to "/auth/#{params[:auth_type]}"
  end
  
  def voted
    redirect_to root_url if !current_user
    session[:badge]= "ivoted_banner" if !session[:badge].match("sopa")
    current_user.update_attributes(:voted=> true)
    @photo = current_provider.photos.last
    render "photos/new"
  end
  
  def index
    render "providers/index"
  end
  
  def show
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
  
  def redirect
    redirect_to "/", :notice => AUTHORIZATION_FAILED if (!@user && !@current_user) || (@current_user != @user)
  end

end