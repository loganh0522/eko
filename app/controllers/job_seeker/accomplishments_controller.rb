class JobSeeker::AccomplishmentsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  def new
    @work_experience = WorkExperience.find(params[:work_experience_id])
    @accomplishment = Accomplishment.new

    respond_to do |format|
      format.js
    end
  end
  
  def create
    @accomplishment = Accomplishment.new(accomplishment_params)  
    @work_experience = WorkExperience.find(params[:work_experience_id])

    respond_to do |format| 
      if @accomplishment.save
        format.js 
      else 
        render_errors(@accomplishment)
        format.js
      end
    end
  end  

  def edit
    @accomplishment = Accomplishment.find(params[:id])
    @work_experience = WorkExperience.find(@accomplishment.work_experience.id)
  end

  def update
    @accomplishment = Accomplishment.find(params[:id])
    @work_experience = WorkExperience.find(params[:work_experience_id])
    respond_to do |format|
      if @accomplishment.update(accomplishment_params)
        format.js
      else
        render_errors(@accomplishment) 
        format.js
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
  
  def render_errors(object)
    @errors = []
    object.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def accomplishment_params
    params.require(:accomplishment).permit(:work_experience_id, :body)
  end
end