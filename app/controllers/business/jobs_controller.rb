class Business::JobsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  
  def index
    @jobs = current_company.jobs
  end

  def new
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)  
    @job.company = current_company

    if @job.save && @job.company == current_company
      @job.user_ids = params[:user_ids]
      redirect_to new_business_job_hiring_team_path(@job)
    else
      render :new
    end
  end

  def show 
    @job = Job.find(params[:id])
    @applicants = @job.applicants
    @stages = @job.stages
  end

  def edit
    @job = Job.find(params[:id])
    @questionairre = @job.questionairre
    @scorecard = @job.scorecard
  end

  def update
    @job = Job.find(params[:id])
    
    if @job.update(job_params)
      flash[:notice] = "#{@job.title} has been updated"
      redirect_to new_business_job_hiring_team_path(@job)
    else
      render :edit
    end
  end

  def close_job 
    @job = Job.find(params[:job_id])
    @job.update_column(:status, "closed")
    redirect_to business_jobs_path
  end

  def archive_job
    @job = Job.find(params[:job_id])
    @job.update_column(:status, "archived")
    redirect_to business_jobs_path
  end

  private 

  def job_params
    params.require(:job).permit(:description, :title, :city, :country, :province, :benefits, 
      :industry_ids, :function_ids, :education_level_ids, :job_kind_ids, :career_level_ids)
  end

end 