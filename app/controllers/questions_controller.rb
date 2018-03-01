class QuestionsController < ApplicationController 

  def index 
    @job = Job.find(params[:job_id])
    @questions = @job.questions

  end

end