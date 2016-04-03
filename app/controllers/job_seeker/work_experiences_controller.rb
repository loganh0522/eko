class JobSeeker::WorkExperiencesController < JobSeekersController
  before_filter :require_user
  def new
    @work_experience = WorkExperience.new
  end
  
  def create 
    @positions = current_user.work_experiences
    @work_experience = WorkExperience.new(position_params.merge!(user: current_user))
    
    respond_to do |format| 
      format.html { 
        if @work_experience.save
          flash[:error] = "Your new work experience was successfully added."
        else 
          flash[:error] = "Something went wrong"
        end
        redirect_to job_seeker_profiles_path
      }
      format.js { }
    end  

  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:title, :company_name, :description, :start_date, :end_date, :current_position, :industry_ids, :function_ids)
  end
end