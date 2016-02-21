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
  end 

  def destroy
    @job = Job.find(params[:job_id])
    @hiring_member = HiringTeam.where(user_id: params[:id], job_id: params[:job_id]).first
    @hiring_member.destroy
    
    redirect_to new_business_job_hiring_team_path(@job)
  end


  private 

  def hiring_member_exists
    (params[:hiring_team][:user_tokens]).split(',').each do |id|
      present = HiringTeam.where(user_id: id, job_id: params[:job_id]).present?
    end
    return present
  end

  def create_hiring_member
    (params[:hiring_team][:user_tokens]).split(',').each do |x|    
      if !HiringTeam.where(user_id: x, job_id: params[:job_id]).present?
        HiringTeam.create(user_id: x, job_id: params[:job_id]) 
      else 
        flash[:error] = "Applicant already exists"
      end
    end
    redirect_to new_business_job_hiring_team_path(@job)
  end

  def team_params
    params.require(:hiring_team).permit(:user_tokens, :job_id)
  end
end