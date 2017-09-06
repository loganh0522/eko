class Business::ApplicationScorecardsController < ApplicationController
  layout "business"
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index 
    if params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @application = @candidate.applications.first
      @scorecard = Scorecard.where(job_id: params[:job_id]).first
      @sections = @scorecard.scorecard_sections
      @application_scorecards = ApplicationScorecard.where(application_id: @application.id)
      @job = Job.find(params[:job_id])
    else
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
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
        track_activity @application_scorecard
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
        track_activity @application_scorecard
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

  def scorecard_graphs
    if @application.application_scorecards.present? 
      @sections = @scorecard.scorecard_sections    
      @application_scorecards = @application.application_scorecards
      @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first
      overall_rating(@application_scorecards, @application)
      
      # @yes = (450 * (@recommended/@application_scorecards.count)).to_i
      # @g =  (450 * (@good/@application_scorecards.count)).to_i
      # @b = (450 * (@bad/@application_scorecards.count)).to_i
      # @no = (450 * (@not_recommended/@application_scorecards.count)).to_i

      # @bar_chart = Gchart.bar(:data => [@yes, @g, @b, @no],
      #   :axis_with_labels => ['y'],
      #   :max_value => 450,
      #   :axis_labels => [["Not Recommended","Bad", "Good", "Recommended",]],
      #   :orientation => 'horizontal',
      #   :bar_colors => 'EF7B2B',
      #   :size => "650x160")
      
      @bar_chart_1 = Gchart.bar(:data => [(450 * (@recommended/@application_scorecards.count))],
        :orientation => 'horizontal',
        :bar_colors => 'EF7B2B',
        :max_value => 450,
        :size => "450x30"
        )
      @bar_chart_2 = Gchart.bar(:data => [(450 * (@good/@application_scorecards.count))],
        :orientation => 'horizontal',
        :bar_colors => 'EF7B2B',
        :max_value => 450,
        :size => "450x30"
        )
      @bar_chart_3 = Gchart.bar(:data => [(450 * (@bad/@application_scorecards.count))],
        :orientation => 'horizontal',
        :bar_colors => 'EF7B2B',
        :max_value => 450,
        :size => "450x30"
        )
      @bar_chart_4 = Gchart.bar(:data => [(450 * (@not_recommended/@application_scorecards.count))],
        :orientation => 'horizontal',
        :bar_colors => 'EF7B2B',
        :max_value => 450,
        :size => "450x30"
        )
    end
  end

  def overall_rating(scorecard, application)
    @recommended = 0.0
    @good = 0.0
    @bad = 0.0
    @not_recommended = 0.0

    scorecard.each do |card|
      if card.overall_ratings.first.rating == 1
        @recommended += 1.0
      elsif card.overall_ratings.first.rating == 2
        @good += 1.0
      elsif card.overall_ratings.first.rating == 3
        @bad += 1.0
      elsif card.overall_ratings.first.rating == 4
        @not_recommended += 1.0
      end  
    end
  end
end