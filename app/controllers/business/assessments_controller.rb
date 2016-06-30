class Business::AssessmentsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?

  def index 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @comment = Comment.new
    
    @questionairre = @job.questionairre
    @answers = @application.question_answers
    @stage = @application.stage
    @user = @application.applicant
    @avatar = @user.user_avatar
  end

end