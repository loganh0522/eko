class Business::ApplicationEmailsController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read

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
      if @email.update(email_params)
        format.js
      else 
        render_errors(@email)
        format.js
      end
    end
  end

  private 

  def email_params
    params.require(:application_email).permit(:subject, :body, :company_id)
  end

  def render_errors(error)
    @errors = []
    error.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end