class Business::HiringTeamsController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index
    @job = Job.find(params[:job_id])
    @users = @job.hiring_teams 

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
    @hiring_team = HiringTeam.create(team_params) 
    
    respond_to do |format| 
      if @hiring_team.save
        @job = Job.find(params[:job_id])
        @users = @job.hiring_teams
        format.js 
      end
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

  private 

  def team_params
    params.require(:hiring_team).permit(:user_id, :job_id)
  end
end