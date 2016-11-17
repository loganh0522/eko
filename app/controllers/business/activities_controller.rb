class Business::ActivitiesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  
  def index
    @activities = current_company.activities.order("created_at desc")
    @jobs = current_company.jobs.where(status: "open")
  end

  def application_activity 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @comment = Comment.new
    @user = @application.applicant
    @positions = @user.work_experiences
    @comments = @application.comments
    @stage = @application.stage
    @avatar = @user.user_avatar   
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
  end
end