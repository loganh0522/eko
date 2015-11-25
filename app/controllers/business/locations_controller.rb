class Business::LocationsController < ApplicationController
  def index
    @subsidiaries = current_company.subsidiaries
    @company = current_company
  end
  
  def show

  end
end