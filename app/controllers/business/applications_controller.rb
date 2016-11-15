class Business::ApplicationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?

  def index
    if params[:query].present? 
      @results = Application.search(params[:query]).records.to_a
      @applicants = []
      
      @results.each do |application|  
        if application.company == current_company
          @applicants.append(application.applicant)
        end
      end

      @jobs = current_company.jobs
      @applications = current_company.applications
    
      @applications.each do |application| 
        @job = Job.find(application.job_id)
      end
    else
      @applicants = current_company.applicants
      @jobs = current_company.jobs
      @applications = current_company.applications
    
      @applications.each do |application| 
        @job = Job.find(application.job_id)
      end
    end
  end

  def show 
    @application = Application.find(params[:id])
    @user = @application.applicant
    @avatar = @user.user_avatar
    @job = Job.find(params[:job_id])
    @stage = @application.stage

    @tags = @application.tags

    @positions = @user.work_experiences
    @education = @user.educations

    @message = Message.new
    @messages = @application.messages

    @comment = Comment.new 
    @comments = @application.comments

    @questionairre = @job.questionairre

    @application_scorecard = ApplicationScorecard.new
    @scorecard = Scorecard.where(job_id: params[:job_id]).first

    @application_scorecard_present = ApplicationScorecard.where(application_id: @application.id)

    scorecard_graphs

    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
  end

  def applicant_search

  end

  def edit

  end

  def update

  end

  

  private

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

  def scorecard_graphs
   if @scorecard.present? 
      @sections = @scorecard.scorecard_sections    
      @application_scorecards = @application.application_scorecards
      @current_user_scorecard = ApplicationScorecard.where(user_id: current_user.id, application_id: @application.id).first


      @application_scorecard_present = ApplicationScorecard.where(application_id: @application.id)

      if @application_scorecard_present.present? 
        @application_scorecard_present.each do |card|
          if card.overall_ratings.present?
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
      end
    end
  end
end