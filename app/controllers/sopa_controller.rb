class SopaController < ApplicationController
  
  before_filter :redirect, :only => [:edit]
  
  def index
    if params[:provider_type].nil?
      render "sopa/index"
    else
      render "sopa/show"
    end
  end
  
  def edit
    @post = Post.new
    render "sopa/edit"
  end
  
  def redirect
    redirect_to "/sopa", :notice => AUTHORIZATION_FAILED if (!@user && !@current_user) || (@current_user != @user)
  end
  
end