class JobSeeker::AccomplishmentsController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new
    @profile = current_user.profile
    @work_experience = WorkExperience.find(params[:work_experience_id])
    @accomplishment = Accomplishment.new
  end
  
  def create
    @profile = current_user.profile
    @accomplishment = Accomplishment.new(accomplishment_params)  
    @work_experience = WorkExperience.find(params[:accomplishment][:work_experience_id])

    respond_to do |format| 
      @errorBody = []
      if @accomplishment.save
        format.js 
      else 
        format.js
        @profile = current_user.profile
        validate_accomplishment(@accomplishment)
      end
    end
  end  

  def edit
    @profile = current_user.profile
    @accomplishment = Accomplishment.find(params[:id])
    @work_experience = WorkExperience.find(@accomplishment.work_experience.id)
  end

  def update
    @profile = current_user.profile
    @accomplishment = Accomplishment.find(params[:id])
    @work_experience  = WorkExperience.find(@accomplishment.work_experience.id)

    respond_to do |format|
      @errorBody = [] 
      if @accomplishment.update(accomplishment_params)
        format.html {redirect_to job_seeker_profiles_path(current_user.id)}
        format.js
      else 
        format.js
        @profile = current_user.profile
        validate_accomplishment(@accomplishment)
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

  def validate_accomplishment(accomplishment)
    if (accomplishment.errors["body"] != nil)
      @errorBody.push(accomplishment.errors["body"][0])
    end  
  end

  def accomplishment_params
    params.require(:accomplishment).permit(:work_experience_id, :body)
  end
end