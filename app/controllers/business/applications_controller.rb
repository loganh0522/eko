class Business::ApplicationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?
  
  def index
    if params[:query].present? 
      @results = Application.search(params[:query]).records.to_a
      @applicants = []
      
      @results.each do |application|  
        if application.company == current_company
          @applicants.append(application.applicant)
        end
      end

      @jobs = current_company.jobs
      @applications = current_company.applications
    
      @applications.each do |application| 
        @job = Job.find(application.job_id)
      end

    else
      @applicants = current_company.applicants
      @jobs = current_company.jobs
      @applications = current_company.applications
    
      @applications.each do |application| 
        @job = Job.find(application.job_id)
      end
    end
  end

  def show 
    @application = Application.find(params[:id])
    @user = @application.applicant
    @avatar = @user.user_avatar
    @job = Job.find(params[:job_id])
    @stage = @application.stage
    @positions = @user.work_experiences
    @education = @user.educations
    @comment = Comment.new 
  end

  def applicant_search

  end

  def edit

  end

  def update

  end
end