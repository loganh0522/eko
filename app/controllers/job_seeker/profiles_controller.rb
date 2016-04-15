class JobSeeker::ProfilesController < JobSeekersController

  def index
    @work_experience = WorkExperience.new
    @accomplishment = Accomplishment.new
    @education = Education.new
    @positions = current_user.work_experiences
    @degrees = current_user.educations
  end

end