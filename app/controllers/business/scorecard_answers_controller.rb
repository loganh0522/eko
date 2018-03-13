class Business::ScorecardAnswersController < ApplicationController
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
    @scorecard = ScorecardAnswer.find(params[:id])
    @assessment = @scorecard.assessment

    respond_to do |format|
      format.js
    end
  end

  def new
    @scorecard_answer = ScorecardAnswer.new
    @scorecard_rating = ScorecardRating.new
    @assessment = Assessment.find(params[:assessment])
    @scorecard = @assessment.scorecard
    @sections = @scorecard.scorecard_sections

    respond_to do |format|
      format.js
    end
  end

  def create
    @scorecard = ScorecardAnswer.new(scorecard_answer_params)
   
    respond_to do |format|
      if @scorecard.save
        # track_activity @application_scorecard, 'create', current_company.id, @application.candidate.id, @job.id   
        format.js
      end 
    end
  end

  def edit 
    @scorecard_answer = ScorecardAnswer.find(params[:id])
    @scorecard = @scorecard_answer.scorecard
    @sections = @scorecard.scorecard_sections

    respond_to do |format| 
      format.js
    end
  end

  def update
    @scorecard_answer = ScorecardAnswer.find(params[:id])
    
    respond_to do |format| 
      if @scorecard_answer.update(scorecard_answer_params)
        format.js
      else
        render_errors(@scorecard_answer)
        format.js
      end
    end
  end

  def destroy
    @scorecard_answer = ScorecardAnswer.find(params[:id])
    @scorecard_answer.destroy  
    
    respond_to do |format|  
      format.js
    end
  end

  private 

  def scorecard_answer_params 
    params.require(:scorecard_answer).permit(:id, :feedback, :overall, :assessment_id, :user_id, :scorecard_id, :job_id, scorecard_ratings_attributes: [:id, :section_option_id, :user_id, :rating, :_destroy])
  end
end