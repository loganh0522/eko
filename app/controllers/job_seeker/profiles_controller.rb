class JobSeeker::ProfilesController < JobSeekersController

  def index
    @work_experience = WorkExperience.new
    @positions = current_user.work_experiences
  end

end