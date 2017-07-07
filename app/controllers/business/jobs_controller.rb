class Business::JobsController < ApplicationController
  filter_access_to :all
  filter_access_to [:close_job, :promote], :require => :read
  filter_access_to :publish_job, :require => :read
  
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
      @jobs = current_user.jobs.where(status: params[:status])     
      respond_to do |format|
        format.js 
      end
    elsif params[:term].present?
      #add open jobs function to company
      @jobs = current_company.jobs.order(:title).where("title ILIKE ?", "%#{params[:term]}%")
      render :json => @jobs.to_json 
    else 
      @jobs = current_user.jobs.where(status: 'open') 
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
    @candidates = @job.applications
    @applications = @job.applications
    @tag = Tag.new
    tags_present(@candidates)  
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

    if params[:status].present? 
      if params[:status] == "open"
        publish_job
      elsif params[:status] == "closed"
        closed_job
      else
        @job.update(status: params[:status])
      end
    else
      if @job.update(job_params)
        convert_location
        track_activity @job
        flash[:notice] = "#{@job.title} has been updated"
        redirect_to new_business_job_hiring_team_path(@job)
      else
        render :edit
      end
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
      @job.update(:status, params[:status]) 
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
    applications.each do |application|
      if application.candidate.tags.present?
        applicant.candidate.tags.each do |tag| 
          @tags.append(tag) unless @tags.include?(tag)
        end
      end
    end
  end

  def job_params
    params.require(:job).permit(:description, :recruiter_description, :title, :location, :address, :benefits, :company_id,
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