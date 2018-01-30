class JobsController < ApplicationController 
  # before_filter :profile_sign_up_complete
  layout :set_layout


  def index 
    @jobs = Job.search("*", where: {status: "open", verified: true})
  end

  def show 
    @job_board = JobBoard.find_by_subdomain!(request.subdomain) if request.subdomain.present?
    @job = Job.find(params[:id])
    @company = @job.company
    @candidate = Candidate.new
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