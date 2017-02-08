class Business::ActivitiesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  
  def index
    @activities = current_company.activities.order("created_at desc")
    @jobs = current_company.jobs.where(status: "open")
  end

end