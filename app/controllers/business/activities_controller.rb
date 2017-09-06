class Business::ActivitiesController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def job_activity
    @job = Job.find(params[:job_id])
    @job.activities
  end
  
  def index    
    if params[:application_id].present?
      @application = Application.find(params[:application_id])
      @activities = @application.activities
    else
      @activities = current_company.activities.order("created_at desc")
      @jobs = current_company.jobs.where(status: "open")
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
  end
end