class JobSeeker::CreateProfilesController < ApplicationController 
  layout "job_seeker"
  before_filter :require_user
  include Wicked::Wizard

  steps :personal, :education, :experience

  def show
    @user = current_user
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
    when :education
      if @user.educations.count == 0 
        @user.educations.new 
      end
      
      render_wizard
    when :experience
      if @user.work_experiences.count == 0 
        @user.work_experiences.build 
      end
      render_wizard
    end

  end
  
  def update
    @user = current_user
    @user.update_attributes(user_params)

    case step

    when :personal
      render_wizard @user
    when :education
      render_wizard @user
    when :experience 
      finish_wizard_path
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
end