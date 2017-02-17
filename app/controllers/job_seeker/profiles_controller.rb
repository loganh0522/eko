class JobSeeker::ProfilesController < JobSeekersController
  before_filter :require_user
  
  def index
    @work_experience = WorkExperience.new
    @accomplishment = Accomplishment.new
    @education = Education.new
    @user_avatar = UserAvatar.new
    @user_skill = UserSkill.new

    
    @skills = current_user.user_skills
    @avatar = current_user.user_avatar
    @current_work = current_user.work_experiences.where(current_position: '1')
  end


        

end