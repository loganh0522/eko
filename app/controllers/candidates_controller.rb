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
      redirect_to :back
      flash[:error] = "Something went wrong please try again"
      respond_to do |format| 
        format.js
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

end