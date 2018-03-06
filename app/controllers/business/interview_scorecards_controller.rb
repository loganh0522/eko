class Business::InterviewScorecardsController < ApplicationController
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
        @application_scorecards = InterviewScorecard.where(application_id: @application.id)
        @current_user_scorecard = InterviewScorecard.where(user_id: current_user.id, application_id: @application.id).first 
      end
    else
      @candidate = Candidate.find(params[:candidate_id])
      @job = Job.find(params[:job])
      @application = Application.where(job: @job, candidate: @candidate).first
      
      @scorecard = @job.scorecard
      @sections = @scorecard.scorecard_sections if @scorecard.present?
      @application_scorecards = InterviewScorecard.where(application_id: @application.id)
      @current_user_scorecard = InterviewScorecard.where(user_id: current_user.id, application_id: @application.id).first 
    end
    
    respond_to do |format|
      format.js
    end
  end

  def new
    @interview_scorecard = InterviewScorecard.new
    @scorecard_rating = ScorecardRating.new
    @interview = Interview.find(params[:interview])
    @candidate = @interview.candidate
    @application = Application.find(params[:application])
    @job = @application.job

    @interview_kit = InterviewKit.find(@interview.interview_kit_id)
    @scorecard = @interview_kit.scorecard
    @sections = @scorecard.scorecard_sections

    respond_to do |format|
      format.js
    end
  end

  def create
    @interview_scorecard = InterviewScorecard.new(interview_scorecard_params.merge!(user: current_user))
   
    respond_to do |format|
      if @interview_scorecard.save
        # track_activity @application_scorecard, 'create', current_company.id, @application.candidate.id, @job.id   
      else
        
      end
      format.js
    end
  end

  def edit 
    @interview_scorecard = InterviewScorecard.find(params[:id])
    @interview = @interview_scorecard.interview
    @candidate = @interview_scorecard.candidate
    @scorecard = @interview_scorecard.scorecard

    @sections = @scorecard.scorecard_sections

    respond_to do |format|
      format.js
    end
  end

  def update
    @interview_scorecard = InterviewScorecard.find(params[:id])
    
    respond_to do |format|
      if @interview_scorecard.update(interview_scorecard_params)
        # track_activity @application_scorecard, 'create', current_company.id, @application.candidate.id, @job.id 
      else
      end
      format.js
    end
  end

  def show 
    @interview_scorecard = InterviewScorecard.find(params[:id])
    
    respond_to do |format| 
      format.js
    end
  end

  private 

  def interview_scorecard_params 
    params.require(:interview_scorecard).permit(:feedback, :interview_id, 
      :candidate_id, :scorecard_id, :job_id, :application_id,
      scorecard_ratings_attributes: [:id, :section_option_id, :body, :user_id, :rating, :_destroy])
  end
end