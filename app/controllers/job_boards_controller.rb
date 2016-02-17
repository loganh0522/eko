class JobBoardsController < ApplicationController 
  def index
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @jobs = @company.jobs
  end

  def show 

  end

end