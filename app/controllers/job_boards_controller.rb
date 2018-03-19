class JobBoardsController < ApplicationController 
  layout :set_layout
  before_filter :profile_sign_up_complete

  def index
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @sections = @job_board.job_board_rows
    @jobs = @company.published_jobs
  end

  def show 

  end

  private

  def set_layout
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    if @job_board.kind == "association"
      "association_portal"
    elsif @job_board.kind == "basic"
      "career_portal"
    else
      "advanced_career_portal"
    end
  end
  
end