class Business::UsersController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  
  def index 
    @invitation = Invitation.new
    @users = current_company.users
  end
end