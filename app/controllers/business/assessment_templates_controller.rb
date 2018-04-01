class Business::AssessmentTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new
    @assessment = AssessmentTemplate.new

    respond_to do |format| 
      format.js
    end
  end

  def index 
    @assessments = current_company.assessment_templates
  end

  def create 
    @assessment = AssessmentTemplate.new(interview_kit_params.merge!(company: current_company)) 

    respond_to do |format|
      if @interview_kit.save
        @assessments = current_company.assessment_templates
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
        @assessments = current_company.interview_kit_templates
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
      @assessments = current_company.assessment_templates
      format.js
    end
  end

  private 

  def assessment_params 
    params.require(:assessment_template).permit(:name, :preperation,
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