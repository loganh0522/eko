class JobSeeker::WorkExperiencesController < JobSeekersController
  before_filter :require_user

  def create 
    @work_experience = WorkExperience.new(position_params.merge!(user: current_user))
    
    if @work_experience.save
      redirect_to job_seeker_profiles_path
    else 
      flash[:error] = "Something went wrong"
      redirect_to job_seeker_profiles_path
    end
  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:title, :company_name, :description, :start_date, :end_date, :current_position)
  end
end