class PhotosController < ApplicationController

  
  def new
    @photo = current_provider.photo
  end
  
  def create
    @photo = Photo.find(params[:photo][:id])
    if @photo.update_attributes(:badge_type => params[:user][:badge], :following => params[:following])
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

end