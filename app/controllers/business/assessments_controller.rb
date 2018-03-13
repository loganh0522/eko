class Business::AssessmentsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    @assessments = current_company.default_stages.order("position")
  end

  def new
    @assessment = Assessment.new
    @scorecard = Scorecard.new
    
    respond_to do |format|
      format.js
    end
  end

  def create 
    @assessment = Assessment.new(stage_params) 

    respond_to do |format| 
      if @assessment.save 
        @assessments = current_company.assessments.order("position")
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

  def stage_params
    params.require(:default_stage).permit(:name, :position, :company_id)
  end

  def render_errors(default_stage)
    @errors = []

    default_stage.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end