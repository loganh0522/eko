class Business::HiringTeamsController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  
  def index
    @company_users = current_company.users.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
    render :json => @company_users.to_json 
  end

  def new
    @hiring_team = HiringTeam.new 
    @job = Job.find(params[:job_id])
    @hiring_teams = @job.hiring_teams 
    @users =  @job.users
    @company_users =  current_company.users
    @invitation = Invitation.new

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def create    
    @hiring_team = HiringTeam.create(team_params) 
    
    respond_to do |format| 
      if @hiring_team.save
        @job = Job.find(params[:job_id])
        @hiring_teams = @job.hiring_teams
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

  # def job_hiring_team
  #   @job = Job.find(params[:job])
  #   @hiring_team = @job.users.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
  #   @team = []
    
  #   @hiring_team.each do |member| 
  #     if member != current_user
  #       @team.append(member)
  #     end
  #   end
  #   render :json => @team.to_json
  # end

  private 

  def team_params
    params.require(:hiring_team).permit(:user_id, :job_id)
  end
end