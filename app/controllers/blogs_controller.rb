class Admin::BlogsController < ApplicationController
  layout "admin"
  before_filter :require_user
  
  
  def index
    @users = User.all
    
    respond_to do |format|
      format.html
    end
  end

  def show 
    @user = User.find(params[:id])

    respond_to do |format|
      format.js
      format.html
    end
  end
end