class Business::JobTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index 
    if params[:subsidiary_id].present?
      @subsidiary = Company.find(params[:subsidiary_id])
      @job_templates = @subsidiary.job_templates
    else
      @job_templates = current_company.job_templates
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @job_template = JobTemplate.new
    @subsidiary = Company.find(params[:subsidiary]) if params[:subsidiary].present?

    respond_to do |format| 
      format.js
      format.html
    end
  end

  def create 
    if params[:subsidiary].present?
      @company = Company.find(params[:subsidiary])
      @job_template = JobTemplate.new(job_params.merge!(company: @company, user: current_user)) 
    else
      @job_template = JobTemplate.new(job_params.merge!(company: current_company, user: current_user)) 
    end

    respond_to do |format|
      if @job_template.save
        format.js
      else 
        render_errors(@job_template)
      end
      format.js
    end
  end

  def edit
    @job_template = JobTemplate.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @job_template = JobTemplate.find(params[:id])
    
    respond_to do |format|
      if @job_template.update(job_params)
        format.js
      else 
        render_errors(@job_template)  
      end
      format.js
    end
  end

  def destroy
    @job_template = JobTemplate.find(params[:id])
    @job_template.destroy

    respond_to do |format|
      @job_templates = current_company.job_templates
      format.js
    end
  end

  private 

  def job_params
    params.require(:job_template).permit(:title, :description, :company_id, :user_id)
  end

  def render_errors(email_template)
    @errors = []

    email_template.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end