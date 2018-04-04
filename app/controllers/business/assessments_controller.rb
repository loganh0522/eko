class Business::AssessmentsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    if params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @assessments = @candidate.assessments
    elsif params[:application_id].present?
      @application = Application.find(params[:application_id])
      @assessments = @application.assessments
    end 

  end

  def new
    @assessment = Assessment.new
    @scorecard = Scorecard.new

    if params[:application_id].present?
      @application = Application.find(params[:application_id]) 
      @candidate = @application.candidate
    else
      @candidate = Candidate.find(params[:candidate_id]) 
    end

    respond_to do |format|
      format.js
    end
  end

  def create 
    @assessment = Assessment.new(assessment_params) 

    respond_to do |format| 
      if @assessment.save 
        format.js
      else
        render_errors(@assessment)
        format.js
      end
    end
  end

  def edit
    @assessment = Assessment.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @assessment = Assessment.find(params[:id])

    respond_to do |format|
      if @assessment.update(stage_params)

        format.js
      else
        render_errors(@assessment)
        format.js
      end 
    end
  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def assessment_params
    params.require(:assessment).permit(:name, :candidate_id, :application_id, :kind,
      scorecard_attributes: [:id, :name,
        section_options_attributes: [:id, :body, :quality_answer, :required, :_destroy, :position]])
  end

  def render_errors(default_stage)
    @errors = []

    default_stage.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end