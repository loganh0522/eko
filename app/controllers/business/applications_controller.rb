class Business::ApplicationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index
    if params[:query].present? 
      @results = Application.search(params[:query]).records.to_a
      @applicants = []
      company_jobs
      company_locations
      @tags = current_company.tags
      @results.each do |application|  
        if application.company == current_company
          @applicants.append(application)
        end
      end 
    else
      @applicants = current_company.applications 
      company_jobs
      company_locations
      @tags = current_company.tags
    end
  end

  def filter_applicants
    @applications = current_company.applications
    @jobs = current_company.jobs
    @applicants = []
    
    @applications.each do |applicant|
      params[:checked].each do |param| 
        @tags = []
        tags_present(applicant)

        if applicant.apps.status == param || 
          applicant.apps.title == param || 
          @tags.include?(param)

          
          @applicants.append(applicant) unless @applicants.include?(applicant)
        else
          @applicants.delete(applicant)
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

  # def mention_user
  #   @job = Job.find(params[:job_id])
  #   @hiring_team = @job.users
  # end

  def show 
    @application = Application.find(params[:id])
    @job = Job.find(params[:job_id])
    @message = Message.new
    @comment = Comment.new 
    @interview = Interview.new
    @application_scorecard = ApplicationScorecard.new
    @hiring_team = @job.users 
    @rating = Rating.new  
    @scorecard = Scorecard.where(job_id: params[:job_id]).first
    @application_scorecard_present = ApplicationScorecard.where(application_id: @application.id)
    scorecard_graphs  
  end

  def applicant_search

  end

  def edit

  end

  def update

  end

  def change_stage 
    @app = Application.find(params[:application])
    @stage = Stage.find(params[:stage])
    @app.update_attribute(:stage, @stage)
  end
  
  def reject
    @application = Application.find(params[:application_id])
    @application.update_attribute(:rejected, true)
    @job = Job.find(params[:job_id])
    respond_to do |format|
      format.js
    end
  end

  private
  
  def tags_present(applicant)
    applicant.tags.each do |tag| 
      @tags.append(tag.name)
    end
  end

  def company_locations
    @locations = []
    current_company.jobs.each do |job|  
      @locations.append(job.location) unless @locations.include?(job.location)
    end
  end

  def company_jobs
    @jobs = []  
    current_company.jobs.each do |job|  
      @jobs.append(job.title) unless @jobs.include?(job.title)
    end
  end

  def scorecard_graphs
   if @scorecard.present? 
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

  #   @recommended = (100 * (@recommend/@application_scorecards.count))
  #   @good = (100 * (@okay/@application_scorecards.count))
  #   @bad = (100 * (@not_okay/@application_scorecards.count))
  #   @not_recommended = (100 * (@not_recommend/@application_scorecards.count))
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