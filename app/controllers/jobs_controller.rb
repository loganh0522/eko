class JobsController < ApplicationController 
  # before_filter :profile_sign_up_complete
  layout :set_layout
  

  def index 
    if params[:company_id].present? && request.subdomain.present?
      @company = Company.find(params[:company_id])
      @jobs = @company.published_jobs
      @job_board = @company.job_board

      render 'company_jobs'
    else
      @jobs = Job.search("*", where: {status: "open", verified: true})
    end
  end

  
  def association_jobs
    @job_board = JobBoard.find_by_subdomain!(request.subdomain) 
    @company = @job_board.company
    @jobs = @company.subsidiary_jobs

    
  end

  def show 
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain) 
    end
    @job = Job.find(params[:id])

    if @job_board.kind == 'association'
      @company = @job_board.company
    else
      @company = @job.company
    end

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