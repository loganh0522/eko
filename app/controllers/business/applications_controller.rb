class Business::ApplicationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

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
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @job = Job.find(params[:job_id])
    @applications = @job.applications
    @tag = Tag.new
    tags_present(@applications) 
    respond_to do |format| 
      format.js
    end
  end

  def show 
    @rejection_reasons = current_company.rejection_reasons
    @application = Application.find(params[:id])  
    @candidate = @application.candidate

    if @candidate.manually_created == true 
      @applicant = @candidate
    else
      @applicant = @candidate.user.profile
    end

    @job = Job.find(params[:job_id])
    @hiring_team = @job.users

    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
  end

  def filter_applicants
    options = {
      average_rating: params[:average_rating],
      tags: params[:tags],
      job_status: params[:job_status],
      date_applied: params[:date_applied],
      job_applied: params[:job_applied],
      location_applied: params[:location_applied]
      }

    @applications = []

    @results = current_company.applications.search(params[:query], options).records.to_a
    
    @results.each do |application|  
      if application.company == current_company
        @applications.append(application)
      end
    end 
    respond_to do |format|
      format.js
    end
  end

  def application_form
    if params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @application = @candidate.application.first
      @questionairre = @application.apps.questionairre
      @questions = @questionairre.questions
    else
      @application = Application.find(params[:application_id])
      @job = Job.find(params[:job_id])
      @questionairre = @application.apps.questionairre
      @questions = @questionairre.questions
    end
     
    respond_to do |format| 
      format.js
    end
  end

  def change_stage 
    @app = Application.find(params[:application])
    @stage = Stage.find(params[:stage])
    @app.update_attribute(:stage, @stage)
    @applications = @app.apps.applications

    @tag = Tag.new
    tags_present(@applications) 
    @job = @app.apps

    respond_to do |format|
      format.js
    end
  end
  
  def reject
    @application = Application.find(params[:application_id])
    @application.update_attributes(rejected: true, rejection_reason: params[:val])
    @job = Job.find(params[:job_id])
    @applications = @job.applications
    
    respond_to do |format|
      format.js
    end
  end

  private

  def tags_present(applications)
    @tags = []
    applications.each do |applicant|
      if applicant.tags.present?
        applicant.tags.each do |tag| 
          @tags.append(tag) unless @tags.include?(tag)
        end
      end
    end
  end

  def application_params
    params.require(:application).permit(:job_id, :company_id, :candidate_id)
  end
end