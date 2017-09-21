class JobsController < ApplicationController 

  before_filter :profile_sign_up_complete
  

  
  def show 
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
    @job = Job.find(params[:id])
    @application = Application.new

    @user = User.new
  end
  
end