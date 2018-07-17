class JobSeeker::CandidatesController < JobSeekersController 
  layout :set_layout
  before_filter :require_user
  before_filter :has_applied?
  # before_filter :profile_sign_up_complete
  # before_filter :resume_application_denied
  # before_filter :ensure_job_seeker

  def new
    @candidate = Candidate.new
    @job = Job.find(params[:job_id])
    @questions = @job.questions

    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain)
      render :portal_new
    else
      render :new
    end
  end

  def create 
    @job = Job.find(params[:job_id])  
    @company = @job.company

    if current_user.candidates.where(company_id: @company.id).present?
      @candidate = @company.candidates.where(user_id: current_user.id).first
      @application = Application.create(candidate_id: @candidate.id, job_id: @job.id, user_id: current_user.id)
      create_application_form(@candidate, @application)
      track_activity @application, "create", @company.id, @candidate.id, params[:job_id]

      redirect_to root_path
    else
      @candidate = Candidate.new(candidate_params.merge(company_id: @company.id, user_id: current_user.id))
      if @candidate.save  
        @application = Application.create(candidate_id: @candidate.id, job_id: @job.id, user_id: current_user.id) 
        create_application_form(@candidate, @application)  
        track_activity @application, "create", @company.id, @candidate.id, params[:job_id]
        flash[:success] = "Your application has been submitted"
        redirect_to root_path
      else
        render :new
        flash[:error] = "Something went wrong please try again"
      end
    end
  end

  private 
  
  def candidate_params
    params.require(:candidate).permit(:first_name, :last_name, :email, :phone, :company_id,
      resumes_attributes: [:id, :name, :_destroy],
      question_answers_attributes: [:id, :body, :job_id, :question_id, :question_option_id, :file])
  end

  def create_application_form(candidate, application)
    @questionairre = Questionairre.create(candidate_id: candidate.id, application_id: application.id) 
    
    @job.questions.each do |question| 
      @question = Question.create(question.attributes.except('id', 'job_id'))
      @question.update_attributes(questionairre_id: @questionairre.id)

      if question.question_options.present?
        question.question_options.each do |option|
          @option = QuestionOption.create(question_id: @question.id, body: option.body)

          params[:candidate][:question_answers_attributes].each do |answer|

            if answer[1][:question_id] == question.id.to_s && answer[1][:question_option_id] == option.id.to_s
              Answer.create(question_id: @question.id, question_option_id: @option.id)
            end
          end

        end
      else
        params[:candidate][:question_answers_attributes].each do |answer|
          if answer[1][:question_id] == question.id.to_s 
            Answer.create(question_id: @question.id, body: answer[1][:body])
          end
        end
      end
    end
  end

  def set_layout
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain)

      if @job_board.kind == "basic"
        "career_portal_profile"
      else
        "career_portal_profile"
      end
    else
      "job_seeker"
    end
  end

end