class JobSeekersController < ApplicationController 
  # before_filter :ensure_job_seeker, :has_applied?, :belongs_to_job_seeker

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

  def belongs_to_job_seeker
    name = controller_name.gsub("Controller","").gsub("_", ' ').singularize
    class_name = name.split.map { |i| i.capitalize }.join('').constantize

    if class_name.find(params[:id]).user != current_user
      flash[:danger] = "Sorry, you do not have permission to access that!"
      redirect_to job_seeker_root_path
    end
  end
end