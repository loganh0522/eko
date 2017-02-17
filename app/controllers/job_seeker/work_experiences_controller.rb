class JobSeeker::WorkExperiencesController < JobSeekersController
  before_filter :require_user
  
  def new
    @work_experience = WorkExperience.new
  end
  
  def create 
    @positions = current_user.work_experiences
    @work_experience = WorkExperience.new(position_params.merge!(user: current_user))
    
    respond_to do |format| 
      if @work_experience.save
        format.js 
      else 
        flash[:danger] = "Something went wrong, please try again."
      end
    end  
  end

  def edit 
    @positions = current_user.work_experiences
    @work_experience = WorkExperience.find(params[:id])
  end

  def update
    @positions = current_user.work_experiences
    @work_experience = WorkExperience.find(params[:id])   
    
    respond_to do |format| 
      if @work_experience.update(position_params)
        format.html { 
          if @work_experience.update(position_params)
            flash[:success] = "#{@work_experience.title} has been updated"
          else 
            flash[:danger] = "Something went wrong"
          end
          redirect_to job_seeker_profiles_path
        }
        format.js 
      end
    end  
  end

  def destroy
    @work_experience = WorkExperience.find(params[:id])
    @work_experience.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private 
  
  def position_params
    params.require(:work_experience).permit(:title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :country_ids, :state_ids, :city)
  end
end