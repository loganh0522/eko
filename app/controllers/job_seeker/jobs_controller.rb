class JobSeeker::JobsController < JobSeekersController
  before_filter :require_user

  def index 
    @jobs = Job.all
    
    @avatar = current_user.user_avatar
  end

  def show 
    @job = Job.find(params[:id])
    @questionairre = @job.questionairre
    @questions = @questionairre.questions
    @application = Application.new

    @avatar = current_user.user_avatar
  end
end