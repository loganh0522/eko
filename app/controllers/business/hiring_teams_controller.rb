class Business::HiringTeamsController < ApplicationController
  layout "business"
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index
    @job = Job.find(params[:job_id])
    @team = @job.hiring_teams 
    @users = current_company.users
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def new
    @hiring_team = HiringTeam.new 
    @job = Job.find(params[:job])
    
    respond_to do |format|
      format.js
    end
  end

  def create    
    @hiring_team = HiringTeam.create(user_id: params[:user_id], job_id: params[:job_id]) 
    
    respond_to do |format| 
      @job = Job.find(params[:job_id])
      @team = @job.hiring_teams
      format.js 
    end  
  end 

  def destroy
    @member = HiringTeam.find(params[:id])
    @job = @member.job

    if @job.users.count > 1
      @member.destroy
    end
    
    respond_to do |format|
      format.js 
    end
  end

  def autocomplete

  end
  private 

  def create_team 
    @user_ids = params[:user_ids].split(',')

    @user_ids.each do |id|
      @hiring_team = HiringTeam.create(user_id: id, job_id: params[:hiring_team][:job_id]) 
    end
  end

  def team_params
    params.require(:hiring_team).permit(:user_ids, :job_id)
  end
end