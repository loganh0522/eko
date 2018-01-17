class JobSeeker::CreateProfilesController < ApplicationController 
  layout :set_layout
  before_filter :require_user
  include Wicked::Wizard

  steps :personal, :education, :experience

  def show
    @user = current_user
    @job_board = JobBoard.find_by_subdomain!(request.subdomain) if request.subdomain.present?

    case step
    
    when :personal
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
      @background = BackgroundImage.new
      render_wizard
    when :education
      if @user.educations.count == 0 
        @user.educations.new 
      end
      
      render_wizard
    
    when :experience
      if @user.work_experiences.count == 0 
        @user.work_experiences.new
      end
      render_wizard
    end
  end
  
  def update
    @user = current_user
    @user.update_attributes(user_params)
    @job_board = JobBoard.find_by_subdomain!(request.subdomain) if request.subdomain.present?

    case step

    when :personal
      render_wizard @user
    when :education
      render_wizard @user
    when :experience 
      if @user.errors.present?
        render_wizard @user
      else 
        finish_wizard_path
      end
    end
  end


  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :tag_line, :location,
      social_links_attributes: [:id, :url, :kind, :_destroy],
      work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy],
      user_certifications_attributes: [:id, :name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires])
  end

  def experience_params
    params.require(:profile).permit(:user_id, 
      work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy],
      user_certifications_attributes: [:id, :name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires])
  end

  def finish_wizard_path
    redirect_to job_seeker_user_path(current_user)
  end

  def set_layout
    if request.subdomain.present? && r.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain)
      if @job_board.kind == "basic"
        "career_portal_profile"
      else
        "career_portal_profile"
      end
    else
      "job_seeker"
    end
  end
end