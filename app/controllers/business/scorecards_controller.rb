class Business::ScorecardsController < ApplicationController 
  filter_access_to :all  
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :has_a_scorecard, only: [:new, :create]
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index 
    @job = Job.find(params[:job_id])
    @scorecard = @job.scorecard

    respond_to do |format| 
      format.html 
      format.js 
    end
  end

  def new 
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.new(scorecard_params)

    respond_to do |format|
      if @scorecard.save 
        format.js
      else
        render_errors(@scorecard)
        format.js
      end
    end
  end

  def edit 
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:id])
    
    respond_to do |format| 
      format.js
    end
  end

  def update
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:id])
    
    respond_to do |format| 
      if @scorecard.update_attributes(scorecard_params)
        format.js
      else
        render_errors(@scorecard)
        format.js
      end
    end
  end

  def destroy
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:id])
    @scorecard.destroy
    
    respond_to do |format| 
      format.js
    end
  end

  # def my_scorecard
  #   @job = Job.find(params[:job_id])
  #   @application = Application.find(params[:application_id])
  #   @rating = SectionOptionRating.new
  #   @overall_rating = OverallRating.new
  # end

  # def applicant_scorecard
  #   @application_scorecard = ApplicationScorecard.new
  #   @overall_rating = OverallRating.new
  #   @job = Job.find(params[:job_id])
  #   @application = Application.find(params[:application_id])
  #   @stage = @application.stage
  #   @comment = Comment.new
  #   @user = @application.applicant
  #   @scorecard = Scorecard.where(job_id: params[:job_id]).first
  #   @sections = @scorecard.scorecard_sections    
  #   @application_scorecards = @application.application_scorecards
  #   @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first
  # end

  private

  def render_errors(question)
    @errors = []
    question.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def scorecard_params 
    params.require(:scorecard).permit(:job_id, :_destroy, scorecard_sections_attributes: [:id, :body, :_destroy, section_options_attributes:[:id, :body, :_destroy]])
  end
end