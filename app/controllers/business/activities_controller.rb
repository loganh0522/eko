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
      @candidate = Application.find(params[:application_id]).candidate
    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
    else
      nil
    end

    where = {}
    where[:job_id] = params[:job_id] if params[:job_id].present?
    where[:candidate_id] = @candidate.id if @candidate.present?
    where[:company_id] = current_company.id

    @activities = Activity.search("*", where: where)
    @jobs = current_company.jobs.where(status: "open")

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