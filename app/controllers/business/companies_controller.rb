class Business::CompaniesController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  include AuthHelper

  def edit 
    @company = current_company

    respond_to do |format|
      format.js
    end
  end

  def update
    @company = current_company
    @company.update(company_params)
    
    respond_to do |format|
      format.js
    end
  end

  def show
    @company = current_company
    @rooms = current_company.rooms
    @login_url = get_room_login_url
  end

  private 

  def company_params
    params.require(:company).permit(:name, :website, :kind)
  end
end