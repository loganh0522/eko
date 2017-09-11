class ApplicationsController < JobSeekersController 
  before_filter :require_user
  before_filter :profile_sign_up_complete

  def new
    @application = Application.new
    @job = Job.find(params[:job_id])
    @questions = @job.questions if @job.questions.present?
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company
  end

  def create 
    if !current_user_candidate?(params[:application][:company_id])
      @candidate = Candidate.create(company_id: params[:application][:company_id], user_id: current_user.id)
      create_application
    else
      find_candidate
      create_application
    end
    redirect_to root_path
  end

  private 

  def application_params 
    params.require(:application).permit(:user_id, :job_id, :company_id, question_answers_attributes: [:id, :body, :question_id, :question_option_id])
  end

  def create_application
    @job = Job.find(params[:application][:job_id])  
    if !current_user_applied?(@job)
      @application = Application.new(application_params.merge!(candidate_id: @candidate.id))
      if @application.save
        flash[:success] = "Your application has been submitted"
        track_activity @application
      else
        render :new
        flash[:error] = "Something went wrong please try again"
      end
    end
  end

  def current_user_candidate?(company)
    @user = User.find(params[:application][:user_id])
    @user.candidates.map(&:company_id).include?(company.to_i)
  end

  def find_candidate
    @user = User.find(params[:application][:user_id])
    @company = Company.find(params[:application][:company_id])
    @candidate = Candidate.where(company_id: @company.id, user_id: @user.id).first
  end

  def current_user_applied?(job)
    current_user.applications.map(&:job_id).include?(job.id)
  end
end