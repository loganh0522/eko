class Business::ApplicationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def new
    @application = Application.new
    @application.work_experiences.build
    @application.educations.build

    respond_to do |format|
      format.js
    end
  end

  def create 
    @application = Application.new(application_params)

    if @application.save
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @tags = current_company.tags
    @application = Application.new
    @application.work_experiences.build
    @application.educations.build
    @application.applicant_contact_details.build

    if params[:query].present? 
      @results = Application.search(params[:query]).records.to_a
      @applicants = []     
      @results.each do |application|  
        if application.company == current_company
          @applicants.append(application)
        end
      end 
    else
      @applicants = current_company.applications 
    end
  end

  def filter_applicants
    options = {
      average_rating: params[:average_rating],
      tags: params[:tags],
      job_status: params[:job_status],
      date_applied: params[:date_applied],
      job_applied: params[:job_applied],
      location_applied: params[:location_applied]
      }

    @applicants = []

    @results = current_company.applications.search(params[:query], options).records.to_a
    
    @results.each do |application|  
      if application.company == current_company
        @applicants.append(application)
      end
    end 

    respond_to do |format|
      format.js
    end
  end

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
    @sections = @scorecard.scorecard_sections
    @application_scorecards = ApplicationScorecard.where(application_id: @application.id)
    scorecard_graphs
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

  def application_params
    params.require(:application).permit(:company_id, work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy],
      user_certifications_attributes: [:id, :name, :agency, :description, :start_month, :start_year, :end_year, :end_month, :expires],
      applicant_contact_details_attributes: [:id, :first_name, :last_name, :email, :phone, :_destroy])
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