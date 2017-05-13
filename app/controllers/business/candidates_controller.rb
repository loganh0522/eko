class Business::CandidatesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def new
    @candidate = Candidate.new
    @candidate.work_experiences.build
    @candidate.educations.build

    respond_to do |format|
      format.js
    end
  end

  def create 
    @candidate = Candidate.new(application_params)

    if @candidate.save
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @tags = current_company.tags
    @candidates = current_company.candidates
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

  private

  def application_params
    params.require(:candidate).permit(:first_name, :last_name, :email, :phone, :location, :company_id, :manually_created, work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy])
  end
end