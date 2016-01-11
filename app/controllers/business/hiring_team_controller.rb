class Business::HiringTeamController < ApplicationController
  
  def new
    @job = Job.find(params[:job_id])
    @users = current_company.users.all
    @invitation = Invitation.new
  end

  def create

  end 

  def edit
    @job = Job.find(params[:job_id])
    @users = current_company.users.all
    @invitation = Invitation.new
  end

  def update

  end
end