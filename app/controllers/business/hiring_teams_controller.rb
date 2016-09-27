class Business::HiringTeamsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?
  
  def index
    @company_users = current_company.users.order(:first_name).where("first_name ILIKE ?", "%#{params[:term]}%")
    render :json => @company_users.to_json 
  end

  def new
    @hiring_team = HiringTeam.new  
    @job = Job.find(params[:job_id])
    @users =  @job.users
    @scorecard = @job.scorecard
    @company_users =  current_company.users
    @invitation = Invitation.new
    @questionairre = @job.questionairre
  end

  def create
    @job = Job.find(params[:job_id])
    @users = @job.users
    create_hiring_member   
  end 

  def destroy
    @job = Job.find(params[:job_id])
    @user = User.find(params[:id])
    @hiring_member = HiringTeam.where(user_id: params[:id], job_id: params[:job_id]).first
    
    if @job.hiring_teams.include?(@hiring_member)
      @hiring_member.destroy 
    end
    
    respond_to do |format|
      format.html {redirect_to new_business_job_hiring_team_path(@job)}
      format.js 
    end
  end

  private 

  def create_hiring_member 
    if !HiringTeam.where(user_id: params[:user_id], job_id: params[:job_id]).present?
      HiringTeam.create(user_id: params[:user_id], job_id: params[:job_id])
    else 
      render :new 
      flash[:danger] = "Team member already exists"
    end

    respond_to do |format| 
      format.html {redirect_to new_business_job_hiring_team_path(@job)}
      format.js 
    end        
  end

  def team_params
    params.require(:hiring_team).permit(:user_tokens, :job_id)
  end
end