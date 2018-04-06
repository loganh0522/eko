class Business::ScorecardTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new
    @scorecard = ScorecardTemplate.new

    respond_to do |format| 
      format.js
    end
  end

  def index 
    @scorecards = current_company.scorecard_templates
  end

  def create 
    @scorecard = ScorecardTemplate.new(scorecard_params.merge!(company: current_company)) 

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