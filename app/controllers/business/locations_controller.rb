class Business::LocationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company

  def index
    @subsidiaries = current_company.subsidiaries
    @company = current_company
  end

  def new 
    @location = Location.new
  end
  
  def show

  end
end