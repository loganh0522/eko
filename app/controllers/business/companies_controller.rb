class Business::CompaniesController < ApplicationController
  filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def edit 
    @company = current_company

    respond_to do |format|
      format.js
    end
  end

  def update
    @company = current_company
    @company.update(company_params)
    
    redirect_to :back
  end

  def show
    @company = current_company
    @rejection_reasons = current_company.rejection_reasons
  end

  private 

  def company_params
    params.require(:company).permit(:name, :website, :kind)
  end
end