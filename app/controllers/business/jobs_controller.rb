class Business::JobsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?
  
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
      @job.update_column(:status, "draft")
      track_activity(@job, "draft")
      redirect_to new_business_job_hiring_team_path(@job)
    else
      render :new
    end
  end

  def show 
    if params[:query].present? 
      @job = Job.find(params[:id])

      @results = Application.search(params[:query]).records.to_a
      @applicants = []
      
      @results.each do |application|  
        if application.company == current_company && application.apps == @job
          @applicants.append(application.applicant)
        end
      end 
      @activities = current_company.activities.where(job_id: @job.id).order('created_at DESC')
      @stages = @job.stages  
    else
      @job = Job.find(params[:id])
      @applicants = @job.applicants
      @activities = current_company.activities.where(job_id: @job.id).order('created_at DESC')
      @stages = @job.stages  
    end   
  end

  def edit
    @job = Job.find(params[:id])
    @questionairre = @job.questionairre
    @scorecard = @job.scorecard
  end

  def update
    @job = Job.find(params[:id])
    
    if @job.update(job_params)
      track_activity @job
      flash[:notice] = "#{@job.title} has been updated"
      redirect_to new_business_job_hiring_team_path(@job)
    else
      redirect_to edit_business_job_path(@job.id)
    end
  end

  def close_job 
    @job = Job.find(params[:job_id])
    @company = current_company
    if @job.update_column(:status, "closed")
      @company.open_jobs -= 1
      @company.save
      track_activity(@job, "closed")
    else
      flash[:danger] = "Sorry, something went wrong, please try again."
      redirect_to :back
    end

    redirect_to business_jobs_path
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

    if @company.subscription == 'start-up' && @company.open_jobs < 1 
      @job.update_column(:status, "open") 
      @company.open_jobs += 1
      @company.save
      track_activity(@job, "published")
      redirect_to business_jobs_path
    elsif @company.subscription == 'basic' && @company.open_jobs < 3
      @job.update_column(:status, "open")
      @company.open_jobs += 1
      @company.save
      track_activity(@job, "published")
      redirect_to business_jobs_path
    elsif @company.subscription == 'team' && @company.open_jobs < 5
      @job.update_column(:status, "open")
      @company.open_jobs += 1
      @company.save
      track_activity(@job, "published")
      redirect_to business_jobs_path
    elsif @company.subscription == 'plus' && @company.open_jobs < 10
      @job.update_column(:status, "open")
      @company.open_jobs += 1
      @company.save
      track_activity(@job, "published")
      redirect_to business_jobs_path
    elsif @company.subscription == 'growth' && @company.open_jobs < 15
      @job.update_column(:status, "open")
      @company.open_jobs += 1
      @company.save
      track_activity(@job, "published")
      redirect_to business_jobs_path
    elsif @company.subscription == 'enterprise'
      @job.update_column(:status, "open")
      @company.open_jobs += 1
      @company.save
      track_activity(@job, "published")
      redirect_to business_jobs_path
    else
      flash[:danger] = "Sorry, you already have the maximum number of open jobs. Please close an open job before publishing another one."
      render :edit
    end
  end

  private 

  def job_params
    params.require(:job).permit(:description, :title, :city, :country_ids, :state_ids, :benefits, 
      :industry_ids, :function_ids, :education_level_ids, :job_kind_ids, :career_level_ids)
  end

end 