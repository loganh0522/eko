class Business::HiringTeamsController < ApplicationController
  layout "business"
  # filter_access_to :all
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

  def create    
    @hiring_team = HiringTeam.create(user_id: params[:user_id], job_id: params[:job_id]) 
    
    respond_to do |format| 
      if @hiring_team.errors.present? 
        render_errors(@hiring_team)
      else
        @job = Job.find(params[:job_id])
        @team = @job.hiring_teams
      end
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

  private 

  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def team_params
    params.require(:hiring_team).permit(:user_ids, :job_id)
  end
end