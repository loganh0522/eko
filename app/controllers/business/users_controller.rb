class Business::UsersController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  
  def index 
    @company = current_company
    @subsidiaries = current_company.subsidiaries
    @users = current_company.users
  end
end