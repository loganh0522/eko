class Admin::JobsController < ApplicationController
  layout "admin"
  before_filter :require_user

  def index
    @jobs = Job.all
    
    respond_to do |format|
      format.html
    end
  end

  def company_jobs
    @company = Company.find(params[:company_id])
    @jobs = @company.jobs
  end

  def new
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)  

    if @job.save && @job.company == current_company
      redirect_to business_job_hiring_teams_path(@job)
    else
      render :new
    end
  end

  def show 
    @job = Job.find(params[:id])
    @applications = @job.applications

    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
      flash[:notice] = "#{@job.title} has been updated"
      redirect_to business_job_hiring_teams_path(@job)
    else
      render :edit
    end
  end


  def autocomplete
    render :json => Job.search(params[:term], where: {company_id: current_company.id}, 
      fields: [{title: :word_start}])
  end

  private 

  def job_params
    params.require(:job).permit(:description, :recruiter_description, 
      :title, :location, :address, :benefits, :company_id,
      :industry_ids, :function_ids, :client_id, :education_level, 
      :kind, :career_level, :status, :user_ids)
  end
end 