class Business::JobsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company, only: [:edit, :show, :update]

  def index
    @jobs = current_company.jobs
  end

  def new
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)  

    if @job.save && @job.company == current_company
      convert_location
      Questionairre.create(job_id: @job.id)
      Scorecard.create(job_id: @job.id)
      HiringTeam.create(job_id: @job.id, user_id: current_user.id)
      create_stages(@job)
      # @job.user_ids = params[:user_ids]
      @job.update_column(:status, "draft")
      job_url
      track_activity(@job, "draft")
      redirect_to new_business_job_hiring_team_path(@job)
    else
      render :new
    end
  end

  def show 
    @job = Job.find(params[:id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @interviews_by_date = @job.interviews.group_by(&:interview_date)
    @rating = Rating.new
    @tag = Tag.new
    if params[:query].present? 
      @applications = Application.where(job_id: @job.id)
      @results = Application.search(params[:query]).records.to_a
      @applicants = [] 
      @results.each do |application|  
        if application.company == current_company && application.apps == @job
          @applicants.append(application)
        end
      end 
      tags_present(@results)
    else 
      tags_present(@job.applications)  
    end
  end

  def edit
    @job = Job.find(params[:id])
    @questionairre = @job.questionairre
    @scorecard = @job.scorecard
  end

  def promote
    @job = Job.find(params[:job_id])
    @questionairre = @job.questionairre
    @scorecard = @job.scorecard
  end

  def update
    @job = Job.find(params[:id])
    
    if @job.update(job_params)
      convert_location
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
    elsif @company.subscription == 'trial' && @company.open_jobs < 3
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

  def job_params
    params.require(:job).permit(:description, :title, :location, :address, :benefits, :company_id,
      :industry_ids, :function_ids, :client_id, :education_level, :kind, :career_level)
  end
  
  def create_stages(job)
    stages = ["Screen", "Phone Interview", "Interview", 
      "Group Interview", "Offer", "Hired"]
    @position = 1 
    stages.each do |stage| 
      Stage.create(name: stage, position: @position, job_id: job.id)
      @position += 1
    end
  end

  def job_url
    @job.update_column(:url, "#{current_company.job_board.subdomain}.talentwiz.ca/jobs/#{@job.id}")
  end

  def convert_location
    location = params[:job][:location].split(',')
    if location.count == 3
      @job.update_column(:city, location[0])
      @job.update_column(:province, location[1])
      @job.update_column(:country, location[2])
    else
      @job.update_column(:city, location[0])
      @job.update_column(:country, location[1])
    end
  end
end 