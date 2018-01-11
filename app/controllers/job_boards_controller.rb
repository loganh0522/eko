class JobBoardsController < ApplicationController 
  # before_filter :profile_sign_up_complete
  layout :set_layout

  def index
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @function = Function.all
    @company = @job_board.company
    @sections = @job_board.job_board_rows
    @jobs = @company.jobs.where(status: 'open')
    @user = User.new
  end

  def show 

  end

  private

  def set_layout
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)

    if @job_board.kind == "basic"
      "career_portal"
    else
      "advanced_career_portal"
    end
  end
end