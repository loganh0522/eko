class Business::LogosController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index

  end

  def new 
    @logo = Logo.new

    respond_to do |format| 
      format.js
    end
  end

  def create
    @logo = Logo.create(logo_params)

    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @logo  = Logo.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @logo  = Logo.find(params[:id])
    @logo.update(logo_params)

    respond_to do |format|
      format.js
    end
  end

  def destroy

  end

  private

  def logo_params
    params.require(:logo).permit(:file, :company_id)
  end
end