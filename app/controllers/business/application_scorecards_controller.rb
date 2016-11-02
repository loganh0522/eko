class Business::ApplicationScorecardsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?

  def index 
    @application_scorecard = ApplicationScorecard.new
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @stage = @application.stage
    @comment = Comment.new
    @user = @application.applicant
    @avatar = @user.user_avatar
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
  end

  def new

  end

  def create
    @job = Job.find(params[:job_id])
    @application_scorecard = ApplicationScorecard.new(application_scorecard_params)
    @application = Application.find(params[:application_id])
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
    
    respond_to do |format|
      if @application_scorecard.save(application_scorecard_params)
        track_activity @application_scorecard
        scorecard_graphs
      else
        redirect_to business_job_application_path(@job.id, @application.id), {:data => {:toggle => "modal", :target => "#edit_scorecardModal"}}
      end
      format.js
    end
  end

  def edit 

  end

  def update
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @application_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first   
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
    
    respond_to do |format|
      if @application_scorecard.update(application_scorecard_params)
        track_activity @application_scorecard
        scorecard_graphs
      else
        redirect_to business_job_application_path(@job.id, @application.id), {:data => {:toggle => "modal", :target => "#edit_scorecardModal"}}
      end
      format.js
    end
  end

  private 

  def application_scorecard_params 
    params.require(:application_scorecard).permit(:id, :application_id, :user_id, :scorecard_id, :job_id, :_destroy, scorecard_ratings_attributes: [:id, :section_option_id, :user_id, :rating, :_destroy], overall_ratings_attributes: [:id, :rating, :user_id, :_destroy])
  end

end