class JobSeeker::ProfilesController < JobSeekersController

  def index
    @work_experience = WorkExperience.new
    @accomplishment = Accomplishment.new
    @positions = current_user.work_experiences
  end

end