class ProfilesController < ApplicationController 
  def index 
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @work_experience = WorkExperience.new
    @positions = current_user.work_experiences
  end
end