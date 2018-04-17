class Business::ApplicationStagesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    @application = Application.find(params[:id])
    @job = @application.job
    @stages = @application.application_stages

    respond_to do |format|
      format.js
    end
  end

  def next_stage
    @application = Application.find(params[:id])
    @candidate = @application.candidate
    
    @job = @application.job
    @current_stage = @application.stage
    @stage = @application.job.stages.where(position: @current_stage.position + 1).first
    @rejection_reasons = current_company.rejection_reasons
    
    @application.update_attribute(:stage_id, @stage.id)  
    
    track_activity @application, "move_stage", @application.candidate.id, @job.id, @stage.id
  end

  def multiple_change_stages
    @job = Job.find(params[:job])

    respond_to do |format|
      format.js
    end
  end

  def move_stage    
    @stage = Stage.find(params[:stage])
    @job = @stage.job
    @rejection_reasons = current_company.rejection_reasons

    if params[:applicant_ids].present?
      move_multiple_stages
      @candidates = Candidate.joins(:applications).where(:applications => {job_id: @job.id}).paginate(page: params[:page], per_page: 10)
    else
      move_stage_single
      @tasks = @candidate.open_job_tasks(@job).accessible_by(current_ability)
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def move_stage_single
    @application = Application.find(params[:id])
    @candidate = @application.candidate
    @job = @stage.job
    @application.update_attribute(:stage, @stage)

    track_activity @app, "move_stage", @application.candidate.id, @application.job.id, @stage.id
  end

  def move_multiple_stages
    applicant_ids = params[:applicant_ids].split(',')
    @job = Job.find(params[:job]) 
    applicant_ids.each do |id| 
      @application = @job.applications.where(candidate_id: id).first
      @application.update_attribute(:stage_id, params[:stage])  
      track_activity @application, "move_stage", @application.candidate.id, @application.job.id, @stage.id
    end
  end
  
end