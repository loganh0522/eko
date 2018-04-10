class Business::AssessmentTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index 
    if params[:subsidiary].present?
      @subsidiary = Subsidiary.find(params[:subsidiary])
      @assessments = @subsidiary.subsidiary.assessment_templates
    else
      @assessments = current_company.assessment_templates
    end
  end

  def new
    @assessment = AssessmentTemplate.new
    @subsidiary = Subsidiary.find(params[:subsidiary]) if params[:subsidiary].present?
    
    respond_to do |format| 
      format.js
    end
  end

  def create 
    if params[:subsidiary].present?
      @company = Subsidiary.find(params[:subsidiary]).subsidiary
      @assessment = AssessmentTemplate.new(assessment_params.merge!(company: @company)) 
    else
      @assessment = AssessmentTemplate.new(assessment_params.merge!(company: current_company)) 
    end
    respond_to do |format|
      if @assessment.save
        format.js
      else 
        render_errors(@assessment)
      end
      format.js
    end
  end

  def edit
    @assessment = AssessmentTemplate.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @assessment = AssessmentTemplate.find(params[:id])
    
    respond_to do |format|
      if @assessment.update(assessment_params)
        format.js
      else 
        render_errors(@assessment)  
      end
      format.js
    end
  end

  def destroy
    @assessment = AssessmentTemplate.find(params[:id])
    @assessment.destroy

    respond_to do |format|
      format.js
    end
  end

  private 

  def assessment_params 
    params.require(:assessment_template).permit(:name,
      questions_attributes: [:id, :kind, :body, :guidelines, :required, :_destroy, :position,
        question_options_attributes: [:id, :body, :_destroy]])   
  end


  def render_errors(interview_kit)
    @errors = []

    interview_kit.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end