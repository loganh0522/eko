class JobSeekersController < ApplicationController 
  before_filter :ensure_job_seeker, :has_applied?

  def ensure_job_seeker  
    if logged_in? && current_user.kind == "business"
      flash[:error] = "You do not have access to this page."   
      redirect_to business_root_path
    end
  end

  def has_applied?
    if current_user.applications.map(&:job_id).include?(params[:job_id].to_i)
      flash[:info] = "You have already applied to this job. Please look at your Applications"
      redirect_to root_path
    end
  end
end