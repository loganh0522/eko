class Business::ApplicationsController < ApplicationController
  
  def index
    @applicants = current_company.applicants
    @jobs = current_company.jobs
    @applications = current_company.applications
    
    @applications.each do |application| 
      @job = Job.find(application.job_id)
    end
  end

  def show 
    @application = Application.find(params[:id])
    @user = @application.applicant
    @job = Job.find(params[:job_id])
    @stage = @application.stage
    @positions = @user.work_experiences
    @education = @user.educations
    @comment = Comment.new 
  end

  def edit

  end

  def update

  end
end