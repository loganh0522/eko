class JobSeeker::ProfilesController < JobSeekersController

  def index
    @work_experience = WorkExperience.new
    @accomplishment = Accomplishment.new
    @education = Education.new
    @positions = current_user.work_experiences
    @degrees = current_user.educations
    @user = current_user
    @user_avatar = UserAvatar.new

    @avatar = current_user.user_avatar
  end

end