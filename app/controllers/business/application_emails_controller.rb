class Business::ApplicationEmailsController < ApplicationController
  filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def edit
    @application_email = ApplicationEmail.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @application_email = ApplicationEmail.find(params[:id])
    respond_to do |format|
      if @application_email.update(e_temp_params)
        format.js
      end
    end
  end

  private 

  def application_email_params
    params.require(:application_email).permit(:subject, :body, :company_id)
  end
end