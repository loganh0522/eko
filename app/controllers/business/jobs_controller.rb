class Business::JobsController < ApplicationController
  # filter_access_to :all
  # filter_access_to [:close_job, :promote], :require => :read
  # filter_access_to :publish_job, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company, only: [:edit, :show, :update]

  def index
    if params[:client_id].present?
      @client = Client.find(params[:client_id])
      @jobs = @client.jobs
    elsif params[:status].present?    
      if current_user.role == "Admin"
        @jobs = current_company.jobs.where(status: params[:status])   
      else
        @jobs = current_user.jobs.where(status: params[:status])  
      end
      respond_to do |format|
        format.js 
      end
    else 
      if current_user.role == "Admin"
        @jobs = current_company.jobs.where(status: 'open') 
      else
        @jobs = current_user.jobs.where(status: 'open') 
      end
      respond_to do |format|
        format.html
        format.js 
      end
    end 
  end

  def new
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)  

    if @job.save && @job.company == current_company
      track_activity(@job, "draft")
      redirect_to business_job_hiring_team_path(@job)
    else
      render :new
    end
  end

  def show 

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
      track_activity @job
      flash[:notice] = "#{@job.title} has been updated"
      redirect_to new_business_job_hiring_team_path(@job)
    else
      render :edit
    end
  end

  def promote
    @job = Job.find(params[:job_id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def close_job 
    @job = Job.find(params[:job_id])
    @company = current_company
    
    respond_to do |format|  
      if @job.update_column(:status, "closed")
        @company.job_count -= 1
        @company.save
        track_activity(@job, "closed")  
        redirect_to :back
      else
        flash[:danger] = "Sorry, something went wrong, please try again."
        redirect_to :back  
      end
    end
  end

  def archive_job
    @job = Job.find(params[:job_id])
    if @job.update_column(:status, "archived")
      track_activity(@job, "archived")
    else
      flash[:danger] = "Sorry, something went wrong, please try again."
      redirect_to :back
    end
    redirect_to business_jobs_path
  end

  def publish_job 
    @job = Job.find(params[:job_id])
    @company = current_company

    respond_to do |format|  
      if @company.max_jobs >=  @company.job_count
        @job.update_attributes(status: 'open') 
        @company.job_count += 1
        @company.save
        
        track_activity(@job, "published")
        redirect_to business_jobs_path   
      else
        format.js
      end
    end
  end

  private 

  def job_params
    params.require(:job).permit(:description, :recruiter_description, 
      :title, :location, :address, :benefits, :company_id,
      :industry_ids, :function_ids, :client_id, :education_level, 
      :kind, :career_level, :status, :user_ids)
  end
end 