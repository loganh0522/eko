class JobSeeker::AccomplishmentsController < JobSeekersController
  before_filter :require_user
  
  def new
    @work_experience = WorkExperience.find(params[:id])
    @accomplishment = Accomplishment.new
  end
  
  def create
    @accomplishment = Accomplishment.new(accomplishment_params)  
    @work_experience = WorkExperience.find(params[:accomplishment][:work_experience_id])

    respond_to do |format| 
      if @accomplishment.save
        format.html { 
          redirect_to job_seeker_profiles_path
        }
        format.js 
      else 
        flash[:danger] = "Something went wrong, please try again."
        redirect_to job_seeker_profiles_path
      end
    end
  end  

  def edit
    @accomplishment = Accomplishment.find(params[:id])
    @work_experience = WorkExperience.find(@accomplishment.work_experience.id)
  end

  def update
    @accomplishment = Accomplishment.find(params[:id])
    @work_experience  = WorkExperience.find(@accomplishment.work_experience.id)

    respond_to do |format| 
      if @accomplishment.update(accomplishment_params)
        format.html {redirect_to job_seeker_profiles_path(current_user.id)}
        format.js
      else
        flash[:error] = "Something went wrong"
        render job_seeker_profiles_path(current_user.id)
      end
    end
  end

  def destroy
    @accomplishment = Accomplishment.find(params[:id])
    @accomplishment.destroy

    respond_to do |format|
      format.html{redirect_to job_seeker_profiles_path}
      format.js
    end
  end

  private 

  def accomplishment_params
    params.require(:accomplishment).permit(:work_experience_id, :body)
  end
end