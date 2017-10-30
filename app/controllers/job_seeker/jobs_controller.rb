class JobSeeker::JobsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete

  def index 
    @jobs = Job.search("*", where: {status: "open"})
    @function = Function.all
    @avatar = current_user.user_avatar
  end

  def show 
    @job = Job.find(params[:id])
    @application = Application.new
    @avatar = current_user.user_avatar
  end
  
end