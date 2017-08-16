class Business::EmailSignaturesController < ApplicationController
  filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :belongs_to_user
  
  def edit
    @signature = EmailSignature.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @signature = EmailSignature.find(params[:id])

    respond_to do |format|
      if @signature.update(e_temp_params)
        format.js
      else 
        render_errors(@signature)
        format.js
      end
    end
  end

  private 

  def render_errors(comment)
    @errors = []
    comment.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def e_temp_params
    params.require(:email_signature).permit(:signature, :user_id)
  end
end