class Business::ApplicationEmailsController < ApplicationController
  layout "business"
  filter_access_to :all
  filter_access_to :filter_candidates, :require => :read

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def edit
    @email = ApplicationEmail.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @email = ApplicationEmail.find(params[:id])
    
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