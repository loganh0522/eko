class Business::CandidatesController < ApplicationController
  filter_access_to :all
  filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def new
    if params[:job].present?
      @job = Job.find(params[:job])
    end
    @candidate = Candidate.new
    @candidate.work_experiences.build
    @candidate.educations.build

    respond_to do |format|
      format.js
    end
  end

  def create 
    @candidate = Candidate.new(candidate_params)
    if @candidate.save
      if params[:job_id].present? 
        @job = Job.find(params[:job_id])
        Application.create(candidate: @candidate, job_id: @job.id, company_id: current_company)
        @applications = @job.applications
      else
        @candidates = current_company.candidates
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    if params[:term].present?
      @candidates = current_company.candidates.order(:first_name).where("first_name ILIKE ?", "%#{params[:term]}%")
      render :json => @candidates.to_json 
    else
      @tags = current_company.tags
      @candidates = current_company.candidates
    end
  end

  def show 
    @candidate = Candidate.find(params[:id])
    
    if @candidate.manually_created == true 
      @applicant = Candidate.find(params[:id])
    else 
      @applicant = @candidate.user.profile
    end

    respond_to do |format|
      format.js
      format.html
    end  
  end

  def filter_candidates
    options = {
      average_rating: params[:average_rating],
      tags: params[:tags],
      job_status: params[:job_status],
      date_applied: params[:date_applied],
      job_applied: params[:job_applied],
      location_applied: params[:location_applied]
      }

    if params[:query].present?
      @candidates = current_company.candidates.search(params[:query], options).records.to_a
    else
      @candidates = current_company.candidates.search('', options).records.to_a
    end


    respond_to do |format|
      format.js
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:first_name, :last_name, :email, :phone, :location, :company_id, :manually_created, work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy], resumes_attributes: [:id, :name, :_destroy])
  end
end