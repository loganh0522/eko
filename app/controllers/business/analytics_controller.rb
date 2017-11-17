class Business::AnalyticsController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def job_activity
    
  end
  
  def index    
    @candidates = current_company.candidates.group_by_day(:created_at).count
  end

  def destroy
    
  end
end