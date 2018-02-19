class Business::EmailTemplatesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new
    @email_template = EmailTemplate.new

    respond_to do |format| 
      format.js
    end
  end

  def index 
    @email_templates = current_company.email_templates
  end

  def create 
    @email_template = EmailTemplate.new(e_temp_params.merge!(company: current_company, user: current_user)) 

    respond_to do |format|
      if @email_template.save
        @email_templates = current_company.email_templates
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
        @email_templates = current_company.email_templates
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
      @email_templates = current_company.email_templates
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