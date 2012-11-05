class SopaController < ApplicationController

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
end