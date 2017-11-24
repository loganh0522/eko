class JobSeeker::ProjectsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete, :only => [:index]
  
  def new
    @user = current_user
    @profile = Project.new
  end

  def create
    @user = current_user
    @profile = Project.new(profile_params)

    if @profile.save 
      flash[:success] = "Your profile was successfully created!"
      redirect_to job_seeker_profiles_path
    else
      render :new
    end
  end

  def index
    @profile = current_user.profile
    @social_links = current_user.social_links
    @avatar = current_user.user_avatar

    if current_user.background_image.present?
      @background = current_user.background_image
    else
      @background = BackgroundImage.new
    end
    
    @work_experiences = @profile.organize_work_experiences
  end

  private 

  def profile_params 
    params.require(:profile).permit(:user_id, work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy],
      user_certifications_attributes: [:id, :name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires])
  end
end