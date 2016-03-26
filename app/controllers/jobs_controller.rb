class JobsController < ApplicationController 
  
  def show 
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @job = Job.find(params[:id])
    @application = Application.new

    # @questionairre = @job.questionairre
    # @questions = @questionairre.questions
  end



end