class PhotosController < ApplicationController

  after_filter :update_provider, :only => :create
  
  def new
    @photo = current_provider.current_photo
  end
  
  def create

    @photo = Photo.find(params[:photo][:id])
    update_user(@photo.user, params)
    if @photo.update_attributes(:badge_type => params[:user][:badge])
      session[:badge] = params[:user][:badge]
      flash[:notice] = BADGE_UPDATED
      redirect_to "/#{session[:provider]}/#{current_provider.uuid}/edit"
    else
      flash[:notice] = BADGE_FAILED
      redirect_to "/#{session[:provider]}/pick_badge"
    end
  end 
  
  def download
    @photo = Photo.find(params[:id])
    @provider = Provider.find(@photo.provider_id)
    file = Photo.read_remote_image(@provider.provider_type, @provider.uuid, @photo.badge.url)
    send_file file, :type => 'image/png', :disposition => 'attachment'
  end
  
  protected
  
  def update_provider
    sleep 2 ## Must wait for Twitter to Update
    if current_provider.provider_type == "twitter"
      @client = Twitter::Client.new(:oauth_token => current_provider.token, :oauth_token_secret => current_provider.secret)
      url = @client.user(current_provider.uuid).profile_image_url(:original)
      atts ={}
      if (url != current_provider.profile_image_url)
        atts.merge!(:profile_image_url => url)
      end
      atts.merge!(:badge_type=> params[:user][:badge]) if !params[:user].nil?
      atts.merge!(:following => (params[:user][:following] == "1")) if !params[:user][:following].blank?
      current_provider.update_attributes(atts)
    end
  end
  
  def update_user(user, params)
    atts = {:badge_type => params[:user][:badge], :pledged => !!params[:user][:badge].match("pledge")}
    atts.merge!(:voted =>  !!params[:user][:badge].match("vote")) if !!params[:user][:badge].match("vote") && !user.voted
    user.update_attributes(atts)
  end

end