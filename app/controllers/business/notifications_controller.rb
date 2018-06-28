class Business::NotificationsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index 
    @notifications = Notification.where(recipient: current_user, company: current_company) 

    respond_to do |format|
      format.js
      format.html
    end
  end
end