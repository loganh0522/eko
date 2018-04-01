class Business::SubsidiariesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new
    @subsidiary = Subsidiary.new

    respond_to do |format| 
      format.js
    end
  end

  def index 
    @email_templates = current_company.email_templates
  end

  def create 
    @company = Company.where(company_number: params[:company_number]).first
    @subsidiary = Subsidiary.new(company: current_company, subsidiary_id: @company.id)

    respond_to do |format|
      if @subsidiary.save
        @subsidiaries = current_company.subsidiaries
      else 
        render_errors(@email_template)
      end
      format.js
    end
  end

  def destroy
    @subsidiary = Subsidiary.find(params[:id])
    @subsidiary.destroy

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