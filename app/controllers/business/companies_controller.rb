class Business::CompaniesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def edit 

  end

  def update

  end

  def show
    
  end
end