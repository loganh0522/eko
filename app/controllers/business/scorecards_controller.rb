class Business::ScorecardsController < ApplicationController 
  layout "business"
  load_and_authorize_resource :job
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index, :show, :destroy]
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index 
    @job = Job.find(params[:job_id])
    @scorecard = @job.scorecard

    respond_to do |format| 
      format.html 
      format.js 
    end
  end

  def new 
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @scorecard = Scorecard.new(scorecard_params.merge!(job_id: params[:scorecard][:job_id]))

    respond_to do |format|
      if @scorecard.save 
        format.js
      else
        render_errors(@scorecard)
        format.js
      end
    end
  end

  def edit 
    @scorecard = Scorecard.find(params[:id])
    @job = @scorecard.job
    
    respond_to do |format| 
      format.js
    end
  end

  def update
    @scorecard = Scorecard.find(params[:id])
    
    respond_to do |format| 
      if @scorecard.update_attributes(scorecard_params)
        format.js
      else
        render_errors(@scorecard)
        format.js
      end
    end
  end

  def destroy
    @scorecard = Scorecard.find(params[:id])
    @scorecard.destroy
    
    respond_to do |format| 
      format.js
    end
  end

  private

  def render_errors(question)
    @errors = []
    question.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def scorecard_params 
    params.require(:scorecard).permit(:job_id, :_destroy, 
      scorecard_sections_attributes: [:id, :body, :_destroy, 
        section_options_attributes:[:id, :body, :_destroy]])
  end
end