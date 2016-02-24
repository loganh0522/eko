class Business::AssessmentsController < ApplicationController
  def index 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])

    @questionairre = @job.questionairre
    @questions = @questionairre.questions
    @answers = @application.question_answers
  end
end