class Business::ApplicationsController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to [:filter_applicants, :application_form], :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
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
    @rejection_reasons = current_company.rejection_reasons
    @tag = Tag.new

    if @candidate.manually_created == true 
      @applicant = @candidate
    else
      @applicant = @candidate.user.profile
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
    @application = Application.find(params[:id])
    @application.destroy
    
    respond_to do |format| 
      format.js
    end
  end

  def application_form
    if !params[:job].present?
      @candidate = Candidate.find(params[:candidate_id])
      @application = @candidate.applications.first       
      
      if @application.present?
        @job = @application.job 
        @questions = @job.questions
      end
    else
      @candidate = Candidate.find(params[:candidate_id])
      @job = Job.find(params[:job])
      @questions = @job.questions
    end

    respond_to do |format| 
      format.js
    end
  end

  def multiple_change_stages
    @job = Job.find(params[:job])
    respond_to do |format|
      format.js
    end
  end

  def move_stage    
    @stage = Stage.find(params[:stage])

    if params[:applicant_ids].present?
      move_multiple_stages
    else
      move_stage_single
    end
    @candidates = Candidate.joins(:applications).where(:applications => {job_id: @job.id}).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
    end
  end
  
  def reject
    @application = Application.find(params[:application_id])
    @application.update_attributes(rejected: true, rejection_reason: params[:val])
    @application.update_attribute(:rejected, true)
    @job = Job.find(params[:job_id])
    @applications = @job.applications

    track_activity @application, "rejected", @application.candidate.id, @job.id

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
    @job = @stage.job
    @application = Application.find(params[:application_id])
    @application.update_attribute(:stage, @stage)
    track_activity @app, "move_stage", @application.candidate.id, @application.job.id, @stage.id
  end

  def move_multiple_stages
    applicant_ids = params[:applicant_ids].split(',')
    @job = Job.find(params[:job]) 
    applicant_ids.each do |id| 
      @application = @job.applications.where(candidate_id: id).first
      @application.update_attribute(:stage_id, params[:stage])  
      track_activity @app, "move_stage", @application.candidate.id, @application.job.id, @stage.id
    end
  end

  def application_params
    params.require(:application).permit(:job_id, :company_id, :candidate_id)
  end
end