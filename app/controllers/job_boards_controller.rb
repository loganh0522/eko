class JobBoardsController < ApplicationController 
  def index
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @function = Function.all
    @company = @job_board.company
    @jobs = @company.jobs.where(status: 'open')
    @user = User.new
  end

  def show 

  end
end