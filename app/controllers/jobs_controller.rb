class JobsController < ApplicationController 
  # before_filter :profile_sign_up_complete
  layout :set_layout
  

  def index 
    @jobs = Job.search("*", where: {status: "open", verified: true})
  end

  def show 
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain) 
    end

    @job = Job.find(params[:id])
    @company = @job.company
    @job_board = @company.job_board
    @candidate = Candidate.new
  end

  private

  def set_layout
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain)

      if @job_board.kind == "association"
        "association_portal"
      elsif @job_board.kind == "basic"
        "career_portal"
      else
        "advanced_career_portal"
      end

    else
      'frontend_job_seeker'
    end
  end
end