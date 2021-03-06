class JobSeeker::CreateProfilesController < ApplicationController 
  layout :set_layout
  before_filter :require_user
  before_filter :completed_sign_up
  include Wicked::Wizard

  steps :personal, :experience, :education, :certification

  def show
    @user = current_user

    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain) 
    end

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

      render_wizard
    when :experience
      @user = current_user
      if @user.work_experiences.count == 0 
        @user.work_experiences.new
      end

      render_wizard
    when :education
      if @user.educations.count == 0 
        @user.educations.new 
      end
  
      render_wizard
    when :certification
      render_wizard
    when :projects
      if @user.educations.count == 0 
        @user.certifications.new 
      end
  
      render_wizard
    end
  end
  
  def update
    @user = current_user
    @user.update_attributes(user_params)
    @job_board = JobBoard.find_by_subdomain!(request.subdomain) if request.subdomain.present? && request.subdomain != 'www'

    case step

    when :personal
      @background = BackgroundImage.new
      render_wizard @user
    when :experience 
      render_wizard @user
    when :education    
      
      render_wizard @user
    when :certification
      @user.update_attributes(profile_stage: "complete")
      finish_wizard_path

    end
  end

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :tag_line, :location,
      social_links_attributes: [:id, :url, :kind, :_destroy],
      
      work_experiences_attributes: [:id, :body, :_destroy, :title, 
        :company_name, :description, :start_month, :start_year, :end_month, :end_year, 
        :current_position, :industry, :function, :location, :skill,
        user_skills_attributes: [:id, :name, :_destroy],
        accomplishments_attributes: [:id, :body, :_destroy]],
      
      educations_attributes: [:id, :school, :degree, :description, :start_month, 
        :start_year, :end_month, :end_year, :_destroy],
      
      user_certifications_attributes: [:id, :name, :agency, :description, 
        :start_month, :start_year, :end_year, :end_month, :expires])
  end



  def finish_wizard_path
    redirect_to job_seeker_user_path(current_user)
  end

  def set_layout
    if request.subdomain.present? && request.subdomain != 'www'
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