class Business::NotificationsController < ApplicationController
  filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index 
    @notifications = current_user.notifications 
  end

  def create
    
  end

end