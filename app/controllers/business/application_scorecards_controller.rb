class Business::ApplicationScorecardsController < ApplicationController
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

  def new
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @current_user_scorecard = ApplicationScorecard.new
    @scorecard = @job.scorecard
    @sections = @scorecard.scorecard_sections

    respond_to do |format|
      format.js
    end
  end

  def create
    @job = Job.find(params[:job_id])
    @application_scorecard = ApplicationScorecard.new(application_scorecard_params)
    @application = Application.find(params[:application_id])
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
    @sections = @scorecard.scorecard_sections
    @application_scorecards = ApplicationScorecard.where(application_id: @application.id) 
   
    respond_to do |format|
      if @application_scorecard.save(application_scorecard_params)
        @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first 
        track_activity @application_scorecard, 'create', current_company.id, @application.candidate.id, @job.id   
      else
        
      end
      format.js
    end
  end

  def edit 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first   
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
    @sections = @scorecard.scorecard_sections
    

    respond_to do |format| 
      format.js
    end
  end

  def update
    @application = Application.find(params[:application_id])
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
    @application_scorecard = ApplicationScorecard.find(params[:id])
    @sections = @scorecard.scorecard_sections
    @application_scorecards = ApplicationScorecard.where(application_id: @application.id)
    @job = Job.find(params[:job_id])
    @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first 
    
    respond_to do |format|
      if @application_scorecard.update(application_scorecard_params)
        track_activity @application_scorecard, 'create', current_company.id, @application.candidate.id, @job.id 
      else
        redirect_to business_job_application_path(@job.id, @application.id), {:data => {:toggle => "modal", :target => "#edit_scorecardModal"}}
      end
      format.js
    end
  end

  private 

  def application_scorecard_params 
    params.require(:application_scorecard).permit(:id, :application_id, :user_id, :scorecard_id, :job_id, :_destroy, scorecard_ratings_attributes: [:id, :section_option_id, :user_id, :rating, :_destroy])
  end
end