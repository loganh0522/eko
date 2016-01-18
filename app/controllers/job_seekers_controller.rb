class JobSeekersController < ApplicationController 
  before_filter :ensure_job_seeker

  def ensure_job_seeker  
    if logged_in? && current_user.kind == "business"
      flash[:error] = "You do not have access to this page."   
      redirect_to business_root_path
    end
  end
end