class Business::ActivitiesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?
  
  def index
    @activities = Activity.order("created_at desc")
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
    
    @activities = Activity.where(application_id: @application.id).order('created_at DESC')
  end
end