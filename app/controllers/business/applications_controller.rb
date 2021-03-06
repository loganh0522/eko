class Business::ApplicationsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  load_and_authorize_resource :job

  def index  
    @job = Job.find(params[:job_id])
    @candidates = Candidate.joins(:applications).where(:applications => {job_id: @job.id}).paginate(page: params[:page], per_page: 10)
    tags_present(@candidates) 

    respond_to do |format| 
      format.js
      format.html
    end
  end

  def new
    @application = Application.new
    @candidate = Candidate.find(params[:candidate_id])

    respond_to do |format|
      format.js
    end
  end

  def create 
    @application = Application.new(application_params)

    if @application.save
      track_activity @application, "create", params[:candidate_id], params[:application][:job_id]

      respond_to do |format|
        format.js
      end
    end
  end

  def new_multiple
    @application = Application.new

    respond_to do |format|
      format.js
    end
  end

  def create_multiple
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @candidate = Candidate.find(id)
      @application = Application.create(job_id: params[:application][:job_id], candidate_id: @candidate.id)
      track_activity @application, "create", @candidate.id, params[:job_id]
    end

    @candidates = current_company.candidates.paginate(page: params[:page], per_page: 10)
    
    respond_to do |format| 
      format.js
    end
  end

  def show 
    @application = Application.find(params[:id]) 
    @candidate = @application.candidate
    @job = Job.find(params[:job_id]) 

    @stages = @application.application_stages

    @interviews = @candidate.upcoming_interviews

    @tasks = @candidate.open_job_tasks(@job).accessible_by(current_ability)
    @rejection_reasons = current_company.rejection_reasons
    @tag = Tag.new

    if @candidate.manually_created == true 
      @applicant = @candidate
    else
      @applicant = @candidate.user
    end

    respond_to do |format|
      format.js
      format.html
    end
  end


  def search 
    where = {}
    qcv_fields = [:work_titles, :work_description, :work_company, :education_description, :education_school]
    fields = [:first_name, :last_name, :full_name, :email]
    
    if params[:query].present?
      query = params[:query] 
    else
      query = "*"
    end
    
    @job = Job.find(params[:job_id])

    where[:company_id] = current_company.id 
    where[:rating] = { gte: params[:rating_filter].to_i } if params[:rating_filter].present?
    where[:jobs] = params[:job_id] if params[:job_id].present?
    where[:application_stage] = params[:stage_id] if params[:stage_id].present?
    where[:application_rejected] = params[:rejected] || false 
    where[:application_hired] = params[:hired] if params[:hired].present?
    where[:tags] = {all: params[:tags]} if params[:tags].present?
    where[:created_at] = {gte: params[:date_applied].to_time, lte: Time.now} if params[:date_applied].present?

    if params[:qcv].present? 
      @candidates = Candidate.accessible_by(current_ability).search(params[:qcv], where: where, fields: qcv_fields, match: :word_start, page: params[:page], per_page: 10)
    else
      @candidates = Candidate.accessible_by(current_ability).search(query, where: where, fields: fields, match: :word_start, page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.js
    end
  end

  def confirm_destroy
    respond_to do |format|
      format.js
    end 
  end

  def destroy_multiple
    @ids = params[:applicant_ids].split(',')

    @ids.each do |id| 
      @application = Application.find(id)
      @application.destroy
    end

    @candidates = Candidate.joins(:applications).where(:applications => {job_id: @job.id}).paginate(page: params[:page], per_page: 10)    
    
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @application = Application.find(params[:id])
    @job = @application.job
    @application.destroy

    redirect_to business_job_applications_path(@job)
  end

  def application_form
    @application = Application.find(params[:id])      
    @candidate = @application.candidate
    @job = @application.job 
    @questions = @job.questions
  

    respond_to do |format| 
      format.js
    end
  end
  
  def next_stage
    @application = Application.find(params[:id])
    @job = @application.job
    @current_stage = @application.stage
    @stage = @application.job.stages.where(position: @current_stage.position + 1).first
    @rejection_reasons = current_company.rejection_reasons
    @candidate = @application.candidate
    @application.update_attributes(stage_id: @stage.id, reviewed: true)  
    @stages = @application.application_stages
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
      @candidates = Candidate.accessible_by(current_ability).search("*", where: {jobs: @job.id, application_stage: @stage.id }, page: params[:page], per_page: 10)
    else
      move_stage_single
      @tasks = @candidate.open_job_tasks(@job).accessible_by(current_ability)
    end

    respond_to do |format|
      format.js
    end
  end

  def reject
    @application = Application.find(params[:id])
    @candidate = @application.candidate
    @job = @application.job
    @rejection_reasons = current_company.rejection_reasons

    if params[:val] == 'requalify'
      @application.update_attributes(rejected: nil, rejection_reason: nil, reviewed: true)
      track_activity @application, "requalified", @application.candidate.id, @job.id
    else
      @application.update_attributes(rejected: true, rejection_reason: params[:val], reviewed: true)
      track_activity @application, "rejected", @application.candidate.id, @job.id
    end

    respond_to do |format|
      format.js
    end
  end

  def stage
    @application = Application.find(params[:id])
    @job = @application.job
    @stages = @application.application_stages

    respond_to do |format|
      format.js
    end
  end

  def quick_screen
    @applications = @job.applications.where(reviewed: false).order(:created_at)
    @candidate = @applications.first.candidate

    @application = @applications.first

    respond_to do |format|
      format.js
    end
  end

  def change_application
    @application = Application.find(params[:id])
    @candidate = @application.candidate
    @job = Job.find(params[:job_id])

    respond_to do |format|
      format.js
    end
  end

  private

  def tags_present(candidates)
    @tags = []
    candidates.each do |candidate|
      if candidate.tags.present?
        candidate.tags.each do |tag| 
          @tags.append(tag) unless @tags.include?(tag)
        end
      end
    end
  end

  def move_stage_single
    @application = Application.find(params[:id])
    @candidate = @application.candidate
    @job = @stage.job
    @application.update_attributes(stage: @stage, reviewed: true)
    @stages = @application.application_stages
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

  def application_params
    params.require(:application).permit(:job_id, :company_id, :candidate_id)
  end
end