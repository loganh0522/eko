class JobSeeker::AccomplishmentsController < JobSeekersController
  before_filter :require_user
  
  def new
    @work_experience = WorkExperience.find(params[:id])
    @accomplishment = Accomplishment.new
  end
  
  def create
    @accomplishment = Accomplishment.new(accomplishment_params)   
    
    if @accomplishment.save
      flash[:error] = "Your new work experience was successfully added."
      redirect_to job_seeker_profiles_path(current_user.id)
    else 
      flash[:error] = "Something went wrong"
    end
  end  

  def edit
    @accomplishment = Accomplishment.find(params[:id])
  end

  def update
    @accomplishment = Accomplishment.find(params[:id])
    if @accomplishment.update(accomplishment_params)
      redirect_to job_seeker_profiles_path(current_user.id)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  private 

  def accomplishment_params
    params.require(:accomplishment).permit(:work_experience_id, :body)
  end
end