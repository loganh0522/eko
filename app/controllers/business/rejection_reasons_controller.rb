class Business::RejectionReasonsController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    @rejection_reasons = current_company.rejection_reasons
    @email = current_company.application_email
  end

  def new
    @rejection_reason = RejectionReason.new
    respond_to do |format| 
      format.js
    end
  end

  def create
    @rejection_reason = RejectionReason.new(rejection_params)

    if @rejection_reason.save
      @rejection_reasons = current_company.rejection_reasons
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @rejection_reason = RejectionReason.find(params[:id])
  end

  def update
    @reason = RejectionReason.find(params[:id])

    if @reason.update(rejection_params)
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @reason = RejectionReason.find(params[:id])

    if @reason.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private
  
  def rejection_params
    params.require(:rejection_reason).permit(:body, :company_id)
  end
end