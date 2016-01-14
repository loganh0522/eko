class JobSeekerController < ApplicationController 
  before_filter :ensure_job_seeker

  def ensure_job_seeker
    flash[:error] = "You do not have access to this page."    
    if logged_in? && current_user.kind == "business"
      redirect_to business_jobs_path
    else
      redirect_to login_path
    end
  end
end