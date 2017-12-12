class Admin::UsersController < ApplicationController
  layout "admin"
  before_filter :require_user
  
  
  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @user = User.new
  end

  def create 
    @job = User.new(user_params)  

    if @job.save && @job.company == current_company
      redirect_to business_job_hiring_teams_path(@job)
    else
      render :new
    end
  end

  def show 
    @user = User.find(params[:id])

    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(job_params)

    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end
end