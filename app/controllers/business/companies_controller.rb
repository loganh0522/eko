class Business::CompaniesController < ApplicationController
  layout "business"

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

  def render_errors(error)
    @errors = []
    error.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end