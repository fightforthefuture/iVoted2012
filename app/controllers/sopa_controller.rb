class SopaController < ApplicationController
  
  before_filter :index_redirect, :only => [:index]
  before_filter :edit_redirect, :only => [:edit]
  
  def index
    if params[:provider_type].nil?
      render "sopa/index"
    else
      @post = Post.new
      render "sopa/show"
    end
  end
  
  def edit
    @post = Post.new
    render "sopa/edit"
  end
  
  def edit_redirect
    redirect_to "/sopa", :notice => AUTHORIZATION_FAILED if (!@user && !current_user) || (current_user != @user)
  end
  
  def index_redirect
    if (params[:action] == "index" && !params[:provider_type].nil?)
      redirect_to "/sopa", :notice => AUTHORIZATION_FAILED if (!@user)
    end
  end
  
end