class Business::EmailTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index 
    if params[:subsidiary_id].present?
      @subsidiary = Company.find(params[:subsidiary_id])
      @email_templates = @subsidiary.email_templates
    else
      @email_templates = current_company.email_templates
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @email_template = EmailTemplate.new
    @subsidiary = Company.find(params[:subsidiary]) if params[:subsidiary].present?

    respond_to do |format| 
      format.js
    end
  end

  def create 
    if params[:subsidiary].present?
      @company = Company.find(params[:subsidiary])
      @email_template = EmailTemplate.new(e_temp_params.merge!(company: @company, 
        user: current_user)) 
    else
      @email_template = EmailTemplate.new(e_temp_params.merge!(company: current_company, 
        user: current_user)) 
    end

    respond_to do |format|
      if @email_template.save
        format.js
      else 
        render_errors(@email_template)
      end
      format.js
    end
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @email_template = EmailTemplate.find(params[:id])
    
    respond_to do |format|
      if @email_template.update(e_temp_params)
        format.js
      else 
        render_errors(@email_template)  
      end
      format.js
    end
  end

  def destroy
    @email_template = EmailTemplate.find(params[:id])
    @email_template.destroy

    respond_to do |format|
      format.js
    end
  end

  private 

  def e_temp_params
    params.require(:email_template).permit(:title, :body, :subject, :company_id, :user_id)
  end

  def render_errors(email_template)
    @errors = []

    email_template.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end