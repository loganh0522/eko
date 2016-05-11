class Business::AssessmentsController < ApplicationController
  def index 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @comment = Comment.new
    
    @questionairre = @job.questionairre
    @answers = @application.question_answers
    @stage = @application.stage
    @user = @application.applicant
  end

end