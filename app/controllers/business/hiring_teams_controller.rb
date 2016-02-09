class Business::HiringTeamsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  
  def new
    @hiring_team = HiringTeam.new
    
    @job = Job.find(params[:job_id])
    @users =  @job.users
    @company_users =  current_company.users
    @invitation = Invitation.new
    @questionairre = @job.questionairre
  end

  def create
    @job = Job.find(params[:job_id])
    create_hiring_member
    redirect_to new_business_job_hiring_team_path(@job)
  end 

  def edit
    @job = Job.find(params[:job_id])
    @users =  @job.users 
    @invitation = Invitation.new
  end

  def update

  end

  private 

  def hiring_member_exists
    (params[:hiring_team][:user_tokens]).split(',').each do |id|
    end
  end

  def create_hiring_member
    (params[:hiring_team][:user_tokens]).split(',').each do |x| 
      HiringTeam.create(user_id: x, job_id: params[:job_id])  
    end
  end

  def team_params
    params.require(:hiring_team).permit(:user_tokens, :job_id)
  end
end