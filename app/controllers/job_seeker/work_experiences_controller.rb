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

  def edit 
    @work_experience = WorkExperience.find(params[:id])
  end

  def update
    @work_experience = WorkExperience.find(params[:id])
    
    if @work_experience.update(position_params)
      flash[:notice] = "#{@job.title} has been updated"
      redirect_to job_seeker_profiles_path
    else
      render :edit
    end
  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :country_ids, :state_ids, :city)
  end
end