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
    @scorecard = Scorecard.where(job_id: params[:job_id]).first

    @sections = @scorecard.scorecard_sections    
    @application_scorecards = @application.application_scorecards
    @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first
  end

  def new

  end

  def create
    @job = Job.find(params[:job_id])
    @application_scorecard = ApplicationScorecard.new(application_scorecard_params)
    @application = Application.find(params[:application_id])
    
    if @application_scorecard.save
      redirect_to business_job_application_application_scorecards_path(@job, @application.id)
    else
      redirect_to new_business_job_application_user_scorecard_path(@job, @application), {:data => {:toggle => "modal", :target => "#scorecardModal"}}
    end
  end

  def edit 

  end

  def update
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @application_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first

    if @application_scorecard.update(application_scorecard_params)
      redirect_to business_job_application_application_scorecards_path(@job, @application.id)
    else
      redirect_to business_job_application_scorecards_path(@job.id, @application.id), {:data => {:toggle => "modal", :target => "#edit_scorecardModal"}}
    end
  end

  private 

  def application_scorecard_params 
    params.require(:application_scorecard).permit(:id, :application_id, :user_id, :scorecard_id, :job_id, :_destroy, scorecard_ratings_attributes: [:id, :section_option_id, :user_id, :rating, :_destroy], overall_ratings_attributes: [:id, :rating, :user_id, :_destroy])
  end
end