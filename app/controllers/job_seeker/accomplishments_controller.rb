class JobSeeker::AccomplishmentsController < JobSeekersController
  before_filter :require_user
  
  def new
    @accomplishment = Accomplishment.new
  end
  
  def create
    binding.pry 
    @accomplishment = Accomplishment.new(accomplishment_params)   
    if @accomplishment.save
      flash[:error] = "Your new work experience was successfully added."
      redirect_to job_seeker_profiles_path(current_user.id)
    else 
      flash[:error] = "Something went wrong"
    end
  end  

  private 

  def accomplishment_params
    params.require(:accomplishment).permit(:work_experience_id, :body)
  end
end