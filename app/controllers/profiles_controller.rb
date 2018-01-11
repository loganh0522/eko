class ProfilesController < ApplicationController 

  before_filter :require_user
  # before_filter :profile_sign_up_complete, :only => [:index]

  def index 
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @avatar = current_user.user_avatar
    # @work_experiences = @profile.organize_work_experiences
  end

  def new
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @user = current_user
    if @user.user_avatar.present?
      @avatar = @user.user_avatar 
    else
      @avatar = UserAvatar.new
    end
    if @user.background_image.present?
      @background = @user.background_image
    else
      @background = BackgroundImage.new 
    end
    @profile = Profile.new
    @profile.work_experiences.build
    @profile.educations.build
  end

  def create
    @user = current_user
    @profile = Profile.new(profile_params)
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    if @profile.save 
      flash[:success] = "Your profile was successfully created!"
      redirect_to profiles_path
    else
      render :new
    end
  end

  private

  def profile_params 
    params.require(:profile).permit(:user_id, work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy],
      user_certifications_attributes: [:id, :name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires])
  end
end