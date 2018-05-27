class CandidatesController < ApplicationController 
  # before_filter :resume_application_denied
  layout :set_layout
  
  def new
    @user = User.new
    @candidate = Candidate.new
    @job = Job.find(params[:job_id])
    @questions = @job.questions
    @job_board = JobBoard.find_by_subdomain!(request.subdomain)
    @company = @job_board.company  
  end

  def create 
    @job = Job.find(params[:job_id])  
    @company = @job.company
    @candidate = Candidate.where(email: params[:candidate][:email], company: @company).first
    
    if @candidate.present?
      @candidate = @company.candidates.where(email: params[:candidate][:email]).first
      @application = Application.create(candidate_id: @candidate.id, job: @job) 
      # track_activity @application, "create", @company.id, @candidate.id, params[:job_id]
      redirect_to root_path
    else
      @candidate = Candidate.new(candidate_params.merge(company_id: @company.id))
      
      if @candidate.save   
        @application = Application.create(candidate_id: @candidate.id, job: @job)   
        flash[:success] = "Your application has been submitted"
        # track_activity @application, "create", @company.id, @candidate.id, params[:job_id]
        redirect_to root_path
      else
        render :new
        flash[:error] = "Something went wrong please try again"
      end
    end
  end

  private 
  
  def candidate_params
    params.require(:candidate).permit(:first_name, :last_name, :email, :phone, 
      :company_id, :manually_created,
      resumes_attributes: [:id, :name, :_destroy],
      question_answers_attributes: [:id, :body, :job_id, :question_id, :question_option_id])
  end

  def render_errors(candidate)
    @errors = []
    candidate.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def set_layout
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain)

      if @job_board.kind == "association"
        "association_portal"
      elsif @job_board.kind == "basic"
        "career_portal"
      else
        "advanced_career_portal"
      end
    else
      'frontend_job_seeker'
    end
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