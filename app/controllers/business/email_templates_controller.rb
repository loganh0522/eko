class Business::EmailTemplatesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index 
    @email_template = EmailTemplate.new
    @email_templates = current_company.email_templates
  end

  def create 
    @email_template = EmailTemplate.new(e_temp_params) 

    respond_to do |format|
      if @email_template.save
        @email_templates = current_company.email_templates
        format.js
      end
    end
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])
  end

  def update
    @email_template = EmailTemplate.find(params[:id])
    respond_to do |format|
      if @email_template.update(e_temp_params)
        format.js
      end
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

end