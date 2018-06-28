class Business::HiringTeamsController < ApplicationController
  layout "business"
  load_and_authorize_resource :job
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index, :show, :destroy]
  
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
        @user = User.find(params[:user_id])
    
        create_notification(@user, @job)
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

  def team_params
    params.require(:hiring_team).permit(:user_ids, :job_id)
  end

  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def create_notification(user, job)
    Notification.create(recipient: user, actor: current_user, action: "added you to", notifiable: job, 
      company_id: current_company.id)
  end
end