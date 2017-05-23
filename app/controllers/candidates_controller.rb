class CandidatesController < JobSeekersController 
  before_filter :require_user
  before_filter :profile_sign_up_complete

  def new
    @candidate = Candidate.new
    @application = Application.new
    
    @job = Job.find(params[:job_id])
    @questionairre = @job.questionairre
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company

    if @questionairre.questions.present? 
      @questions = @questionairre.questions
    end
  end

  def create 
    job = Job.find(params[:application][:job_id])  
    if !current_user_applied?(job)
      @application = Application.new(application_params)
      if @application.save 
        flash[:success] = "Your application has been submitted"
        track_activity @application
        redirect_to root_path
      else
        render :new
        flash[:error] = "Something went wrong please try again"
      end
    else
      flash[:error] = "You have already applied to this job"
      redirect_to root_path
    end
  end

  private 

  def application_params 
    params.require(:application).permit(:user_id, :job_id, :company_id, question_answers_attributes: [:id, :body, :question_id, :question_option_id])
  end

  def create_application
    Application.create(user: current_user, job: job) unless current_user_applied?(job)
  end

  def current_user_applied?(job)
    current_user.applications.map(&:job_id).include?(job.id)
  end
end