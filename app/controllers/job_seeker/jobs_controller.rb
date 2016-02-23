class JobSeeker::JobsController < JobSeekersController
  before_filter :require_user

  def index 
    @jobs = Job.all
  end

  def show 
    @job = Job.find(params[:id])
    @questionairre = @job.questionairre
    @questions = @questionairre.questions
    @application = Application.new
  end
end