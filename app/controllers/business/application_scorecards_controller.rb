class Business::ApplicationScorecardsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
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

  def scorecard_graphs
   if @scorecard.present? 
      @sections = @scorecard.scorecard_sections    
      @application_scorecards = @application.application_scorecards
      @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first

      overall_rating(@application_scorecards, @application)
      
      @yes = (450 * (@recommended/@application_scorecards.count)).to_i
      @g =  (450 * (@good/@application_scorecards.count)).to_i
      @b = (450 * (@bad/@application_scorecards.count)).to_i
      @no = (450 * (@not_recommended/@application_scorecards.count)).to_i

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

  # def overall_rating(scorecard, application)
  #   @recommend = 0
  #   @okay = 0
  #   @not_okay = 0
  #   @not_recommend = 0

  #   scorecard.each do |card|
  #     if card.overall_ratings.first.rating == 1
  #       @recommend += 1
  #     elsif card.overall_ratings.first.rating == 2
  #       @okay += 1
  #     elsif card.overall_ratings.first.rating == 3
  #       @not_okay += 1
  #     elsif card.overall_ratings.first.rating == 4
  #       @not_recommend += 1
  #     end  
  #   end

  #   # @recommended = (100 * (@recommend/@application_scorecards.count))
  #   # @good = (100 * (@okay/@application_scorecards.count))
  #   # @bad = (100 * (@not_okay/@application_scorecards.count))
  #   # @not_recommended = (100 * (@not_recommend/@application_scorecards.count))
  # end

  # def scorecard_graphs
  #  if @scorecard.present? 
  #     @sections = @scorecard.scorecard_sections    
  #     @application_scorecards = @application.application_scorecards
  #     @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first
  #     @application_scorecard_present = ApplicationScorecard.where(application_id: @application.id)

  #     if @application_scorecard_present.present? 
  #       @application_scorecard_present.each do |card|
  #         if card.overall_ratings.present?
  #           overall_rating(@application_scorecards, @application)
            
  #           @yes = (450 * (@recommended/@application_scorecards.count)).to_i
  #           @g =  (450 * (@good/@application_scorecards.count)).to_i
  #           @b = (450 * (@bad/@application_scorecards.count)).to_i
  #           @no = (450 * (@not_recommended/@application_scorecards.count)).to_i


  #           @data = [@recommended, @bad, @good, @not_recommended]
    
  #           @graph_data = []
  #           @data.each do |total|  
  #             @data_point = (450 * (total/@application_scorecards.count))
  #             @graph_data.append(@data_point)
  #           end

  #           # @bar_chart = Gchart.bar(:data => @graph_data,
  #           #   :axis_with_labels => ['y'],
  #           #   :max_value => 450,
  #           #   :axis_labels => [["Not Recommended","Bad", "Good", "Recommended",]],
  #           #   :orientation => 'horizontal',
  #           #   :bar_colors => 'EF7B2B',
  #           #   :size => "650x160",
  #           #   :axis => "none"
  #           #   )
        
  #           @bar_chart_1 = Gchart.bar(:data => [(450 * (@recommended/@application_scorecards.count))],
  #             :orientation => 'horizontal',
  #             :bar_colors => 'EF7B2B',
  #             :max_value => 450,
  #             :size => "450x30",
  #             :axis => 'none'
  #             )
  #           @bar_chart_2 = Gchart.bar(:data => [(450 * (@good/@application_scorecards.count))],
  #             :orientation => 'horizontal',
  #             :bar_colors => 'EF7B2B',
  #             :max_value => 450,
  #             :size => "450x30",
  #             :axis => 'none'
  #             )
  #           @bar_chart_3 = Gchart.bar(:data => [(450 * (@bad/@application_scorecards.count))],
  #             :orientation => 'horizontal',
  #             :bar_colors => 'EF7B2B',
  #             :max_value => 450,
  #             :size => "450x30",
  #             :axis => 'none'
  #             )
  #           @bar_chart_4 = Gchart.bar(:data => [(450 * (@not_recommended/@application_scorecards.count))],
  #             :orientation => 'horizontal',
  #             :bar_colors => 'EF7B2B',
  #             :max_value => 450,
  #             :size => "450x30",
  #             :axis => 'none'
  #             )
  #         end
  #       end
  #     end
  #   end
  # end

end