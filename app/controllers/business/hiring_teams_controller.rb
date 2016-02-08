class Business::HiringTeamsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  
  def new
    @job = Job.find(params[:job_id])
    @users =  @job.users
    @company_users =  current_company.users
    @invitation = Invitation.new
    @questionairre = @job.questionairre
    
    # respond_to do |format| 
    #   format.html 
    #   format.json { render json: @company_users }
    # end
  end

  def create
    @job = Job.find(params[:job_id])
    @job.users.append(User.find(params[:user][:id]))
    redirect_to new_business_job_hiring_team_path(@job)
  end 

  def edit
    @job = Job.find(params[:job_id])
    @users =  @job.users 
    @invitation = Invitation.new
  end

  def update

  end
end