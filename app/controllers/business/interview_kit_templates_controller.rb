class Business::InterviewKitTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new
    @interview_kit = InterviewKitTemplate.new
    @scorecard = Scorecard.new
    respond_to do |format| 
      format.js
    end
  end

  def index 
    @interview_kits = current_company.interview_kit_templates
  end

  def create 
    @interview_kit = InterviewKitTemplate.new(interview_kit_params.merge!(company: current_company)) 

    respond_to do |format|
      if @interview_kit.save
        @interview_kits = current_company.interview_kit_templates
      else 
        render_errors(@interview_kit)
      end
      format.js
    end
  end

  def edit
    @interview_kit = InterviewKitTemplate.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update

    @interview_kit = InterviewKitTemplate.find(params[:id])
    
    respond_to do |format|
      if @interview_kit.update(interview_kit_params)
        @interview_kits = current_company.interview_kit_templates
      else 
        render_errors(@interview_kit)  
      end
      format.js
    end
  end

  def destroy
    @interview_kit = InterviewKitTemplate.find(params[:id])
    @interview_kit.destroy

    respond_to do |format|
      @interview_kits = current_company.interview_kit_templates
      format.js
    end
  end

  private 

  def interview_kit_params 
    params.require(:interview_kit_template).permit(:title, :preperation,
      questions_attributes: [:id, :kind, :body, :guidelines, :required, :_destroy, 
        question_options_attributes: [:id, :body, :_destroy]], 
      
      scorecard_attributes: [:id,
        scorecard_sections_attributes: [:id, :body, :_destroy, 
          section_options_attributes:[:id, :body, :quality_answer, :_destroy]]])   
  end


  def render_errors(interview_kit)
    @errors = []

    interview_kit.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end