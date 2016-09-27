class ProfilesController < ApplicationController 
  def index
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company

    @work_experience = WorkExperience.new
    @accomplishment = Accomplishment.new
    @education = Education.new
    @positions = current_user.work_experiences
    @degrees = current_user.educations
    @user = current_user
    @user_avatar = UserAvatar.new
    @skills = current_user.user_skills
    @avatar = current_user.user_avatar
    @user_skill = UserSkill.new
    @certifications = current_user.user_certifications
    @current_work = current_user.work_experiences.where(current_position: '1')
  end

end