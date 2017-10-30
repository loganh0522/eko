class JobSeeker::ApplicationsController < JobSeekersController 
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  before_filter :ensure_job_seeker
  before_filter :has_applied?
  
  def new
    @application = Application.new
    @job = Job.find(params[:job_id])
    @questions = @job.questions if @job.questions.present?
  end

  def create 
    if !current_user_candidate?(params[:application][:company_id])
      @candidate = Candidate.create(company_id: params[:application][:company_id], user_id: current_user.id, manually_created: false)
      create_application
    else
      find_candidate(params[:application][:company_id])
      create_application
    end
    redirect_to root_path
  end

  private 

  def application_params 
    params.require(:application).permit(:user_id, :job_id, 
      :company_id, 
      question_answers_attributes: [:id, :body, :question_id, :question_option_id])
  end

  def create_application
    @job = Job.find(params[:application][:job_id])  
    @application = Application.new(application_params.merge!(candidate_id: @candidate.id))
      
    if @application.save
      flash[:success] = "Your application has been submitted"
      track_activity @application, "applied", @job.company.id, @candidate.id, @job.id
    else
      render :new
      flash[:error] = "Something went wrong please try again"
    end
  end

  def current_user_candidate?(company)
    current_user.candidates.map(&:company_id).include?(company.to_i)
  end

  def find_candidate(company)
    @candidate = Candidate.where(company_id: company.to_i, user_id: current_user.id).first
  end
end