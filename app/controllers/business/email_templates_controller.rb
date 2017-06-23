class Business::EmailTemplatesController < ApplicationController
  filter_access_to :all
  filter_access_to :filter_candidates, :require => :read
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
    @email_template = EmailTemplate.new
    @email_templates = current_company.email_templates
    @rejection_reasons = current_company.rejection_reasons
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

    respond_to do |format| 
      format.js
    end
  end

  def update
    @email_template = EmailTemplate.find(params[:id])
    respond_to do |format|
      if @email_template.update(e_temp_params)
        @email_templates = current_company.email_templates
        format.js
      end
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

end