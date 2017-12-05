class JobSeeker::CandidatesController < ApplicationController 
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete

  def new
    @candidate = Candidate.new
    @application = Candidate.new
    @job = Job.find(params[:job_id])
    @questions = @job.questions
  end

  def create 
    @job = Job.find(params[:job_id])  
    @company = @job.company
    
    if @company.candidates.where(email: params[:candidate][:email]).present?
      @candidate = @company.candidates.where(email: params[:candidate][:email]).first
      @application = Application.create(candidate_id: @candidate.id, job_id: @job) 
      track_activity @application, "create", @company.id, @candidate.id, params[:job_id]
      redirect_to root_path
    else
      @candidate = Candidate.new(candidate_params)
      if @candidate.save   
        @application = Application.create(candidate_id: @candidate.id, job_id: @job)   
        flash[:success] = "Your application has been submitted"
        track_activity @application, "create", @company.id, @candidate.id, params[:job_id]
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
      question_answers_attributes: [:id, :body, :job_id, :question_id, :question_option_id])
  end

end