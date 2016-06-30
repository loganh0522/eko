class JobSeeker::EducationsController < JobSeekersController
  before_filter :require_user
  
  def index 
    @education = Education.new
    @user_degrees = current_user.educations
  end

  def new
    @education = Education.new
  end

  def create 
    @education = Education.new(education_params.merge!(user: current_user))
    
    respond_to do |format| 
      format.html { 
        if @education.save
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

  def education_params
    params.require(:education).permit(:school, :degree, :description, :start_month, :start_year, :end_month, :end_year)
  end
end