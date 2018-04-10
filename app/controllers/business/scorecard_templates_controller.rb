class Business::ScorecardTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index 
    if params[:subsidiary].present?
      @subsidiary = Subsidiary.find(params[:subsidiary])
      @scorecards = @subsidiary.subsidiary.scorecard_templates
    else
      @scorecards = current_company.scorecard_templates
    end
  end
  
  def new
    @scorecard = ScorecardTemplate.new
    @subsidiary = Subsidiary.find(params[:subsidiary]) if params[:subsidiary].present?
    
    respond_to do |format| 
      format.js
    end
  end

  def create 
    if params[:subsidiary].present?
      @company = Subsidiary.find(params[:subsidiary]).subsidiary
      @scorecard = ScorecardTemplate.new(scorecard_params.merge!(company: @company))
    else
      @scorecard = ScorecardTemplate.new(scorecard_params.merge!(company: current_company)) 
    end
    
    respond_to do |format|
      if @scorecard.save
        format.js
      else 
        render_errors(@scorecard)
      end
      format.js
    end
  end

  def edit
    @scorecard = ScorecardTemplate.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @scorecard = ScorecardTemplate.find(params[:id])
    
    respond_to do |format|
      if @scorecard.update(scorecard_params)
        format.js
      else 
        render_errors(@scorecard)  
      end
      format.js
    end
  end

  def destroy
    @scorecard = ScorecardTemplate.find(params[:id])
    @scorecard.destroy

    respond_to do |format|
      @scorecards = current_company.scorecard_templates
      format.js
    end
  end

  private 

  def scorecard_params 
    params.require(:scorecard_template).permit(:name,
      section_options_attributes: [:id, :body, :guidelines, :required, :_destroy, :position])   
  end


  def render_errors(interview_kit)
    @errors = []

    interview_kit.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end