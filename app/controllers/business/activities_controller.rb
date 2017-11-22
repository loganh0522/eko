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
    @candidate = Candidate.find(params[:candidate_id]) if params[:candidate_id].present?

    where = {}
    where[:trackable_type] = {all: params[:kind]} if params[:kind].present?
    where[:job_id] = params[:job] if params[:job].present?
    where[:candidate_id] = @candidate.id if @candidate.present?
    where[:company_id] = current_company.id

    @activities = Activity.search("*", where: where, order: {created_at: :desc}).to_a
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