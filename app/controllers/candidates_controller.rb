class CandidatesController < ApplicationController 
  before_filter :resume_application_denied
  layout 'career_portal'
  
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
    @candidate = Candidate.new(candidate_params)

    if @candidate.save   
      @application = Application.create(candidate_id: @candidate.id, job_id: @job.id)   
      flash[:success] = "Your application has been submitted"
      redirect_to root_path
    else
      flash[:error] = "Something went wrong please try again"
      @user = User.new
      @candidate = Candidate.new(candidate_params)
      @questions = @job.questions
      @candidate.question_answers.build
      render :new
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
end