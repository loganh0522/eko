class JobSeeker::JobsController < JobSeekersController
  before_filter :require_user
  before_filter :profile_sign_up_complete

  def index 
    @jobs = Job.all
    @function = Function.all
    @avatar = current_user.user_avatar
  end

  def show 
    @job = Job.find(params[:id])
    @questionairre = @job.questionairre
    if @questionairre.present? 
      @questions = @questionairre.questions
    end
    @application = Application.new

    @avatar = current_user.user_avatar
  end
end