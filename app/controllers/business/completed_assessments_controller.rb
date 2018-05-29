class Business::CompletedAssessmentsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index 
    if !params[:job].present?
      @candidate = Candidate.find(params[:candidate_id])
      @application = @candidate.applications.first
      if @application.present?
        @job = @application.job
        @scorecard = Scorecard.where(job_id: @job.id).first
        @sections = @scorecard.scorecard_sections
        @application_scorecards = ApplicationScorecard.where(application_id: @application.id)
        @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first 
      end
    else
      @candidate = Candidate.find(params[:candidate_id])
      @job = Job.find(params[:job])
      @application = Application.where(job: @job, candidate: @candidate).first
      
      @scorecard = @job.scorecard
      @sections = @scorecard.scorecard_sections if @scorecard.present?
      @application_scorecards = ApplicationScorecard.where(application_id: @application.id)
      @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first 
    end
    
    respond_to do |format|
      format.js
    end
  end

  def show 
    @completed_assessment = CompletedAssessment.find(params[:id])
    @assessment = @completed_assessment.assessment
    @scorecard = @assessment.scorecard
    @sections = @scorecard.scorecard_sections
    @questions = @assessment.questions.order(:position)

    respond_to do |format|
      format.js
    end
  end

  def new
    @completed_assessment = CompletedAssessment.new
    @assessment = Assessment.find(params[:assessment])
    
    @questions = @assessment.questions.order(:position)
    @answer = Answer.new
    
    @scorecard = @assessment.scorecard
    @sections = @scorecard.scorecard_sections

    @application = @assessment.application 
    @candidate = @application.candidate
    @job = @application.job

    if @candidate.manually_created == true 
      @applicant = @candidate
    else
      @applicant = @candidate.user
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def interview_kit
    @completed_assessment = CompletedAssessment.new
    @assessment = Assessment.find(params[:id])
    
    @questions = @assessment.questions.order(:position)
    @answer = Answer.new
    
    @scorecard = @assessment.scorecard
    @sections = @scorecard.scorecard_sections
    
    if @assessment.candidate_id.present?
      @candidate = Candidate.find(@assessment.candidate_id)
    else
      @application = @assessment.application 
      @candidate = @application.candidate
      @job = @application.job
    end

    if @candidate.manually_created == true 
      @applicant = @candidate
    else
      @applicant = @candidate.user
    end
  end

  def create
    @assessment = CompletedAssessment.new(completed_assessment_params.merge!(user_id: current_user.id))

    respond_to do |format|
      if @assessment.save
        # track_activity @application_scorecard, 'create', current_company.id, @application.candidate.id, @job.id   
        format.js
      end 
    end
  end

  def edit 
    @completed_assessment = CompletedAssessment.find(params[:id])
    @assessment = @completed_assessment.assessment
    @scorecard = @assessment.scorecard
    @sections = @scorecard.scorecard_sections
    @questions = @assessment.questions

    respond_to do |format| 
      format.js
    end
  end

  def update
    @assessment = CompletedAssessment.find(params[:id])
    
    respond_to do |format| 
      if @assessment.update(completed_assessment_params)
        format.js
      else
        render_errors(@assessment)
        format.js
      end
    end
  end

  def destroy
    @assessment = CompletedAssessment.find(params[:id])
    @assessment.destroy  
    
    respond_to do |format|  
      format.js
    end
  end

  private 

  def completed_assessment_params 
    params.require(:completed_assessment).permit(:id, :feedback, :overall, :assessment_id, :user_id, 
      :scorecard_id, :job_id, 
      answers_attributes: [:id, :body, :question_id, :question_option_id, :section_option_id, 
        :user_id, :rating, :_destroy])
  end

end