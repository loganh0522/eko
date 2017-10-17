class JobsController < ApplicationController 
  before_filter :profile_sign_up_complete
  layout :set_layout
  
  def show 
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @job = Job.find(params[:id])
    @application = Application.new
    @user = User.new
  end



  private

  def set_layout
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)

    if @job_board.kind == "basic"
      "career_portal"
    else
      "advanced_career_portal"
    end
  end
end