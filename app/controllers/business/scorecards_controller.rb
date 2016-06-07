class Business::ScorecardsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :has_a_scorecard, only: [:new, :create]
  before_filter :company_deactivated?

  def index 
   @job = Job.find(params[:job_id])
    @questionairre = @job.questionairre
    @scorecard = Scorecard.where(job_id: @job.id).first
  end

  def new 
    @job = Job.find(params[:job_id])
    @questionairre = @job.questionairre
    @scorecard = Scorecard.new
  end

  def create
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.new(scorecard_params)

    if @scorecard.save 
      flash[:success] = "Scorecard successfully created"
      redirect_to edit_business_job_scorecard_path(@job.id, @scorecard.id)
    else
      render :new
    end
  end

  def edit 
    @job = Job.find(params[:job_id])
    @questionairre = @job.questionairre
    @scorecard = Scorecard.where(job_id: @job.id).first
  end

  def update
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.where(job_id: @job.id).first
    
    if @scorecard.update_attributes(scorecard_params)
      flash[:success] = "Your application form has been updated"
      redirect_to edit_business_job_scorecard_path(@job.id, @scorecard.id)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  def my_scorecard
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @rating = SectionOptionRating.new
    @overall_rating = OverallRating.new
  end

  def applicant_scorecard
    @application_scorecard = ApplicationScorecard.new
    @overall_rating = OverallRating.new
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


  private

  def scorecard_params 
    params.require(:scorecard).permit(:job_id, :_destroy, scorecard_sections_attributes: [:id, :body, section_options_attributes:[:id, :body, :_destroy]])
  end
end