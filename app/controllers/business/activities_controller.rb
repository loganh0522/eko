class Business::ActivitiesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   

    if !params[:application_id].present? && params[:job_id].present?
      @job = Job.find(params[:job_id])
    elsif params[:application_id].present?

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