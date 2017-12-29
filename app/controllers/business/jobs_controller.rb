class Business::JobsController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to [:close_job, :promote], :require => :read
  # filter_access_to :publish_job, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company, only: [:edit, :show, :update]

  def index
    @jobs = current_company.open_jobs

    respond_to do |format|
      format.html
    end
  end

  def new
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)  

    if @job.save 
      redirect_to business_job_hiring_teams_path(@job)
    else
      render :new 
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

    respond_to do |format|
      if params[:status].present? 
        if @job.update(status: params[:status])
          @job.reindex
          format.js
        else 
          redirect_to :back
          flash[:danger] = "Something went wrong, please try again."
        end
      else
        if @job.update(job_params)
          format.html {redirect_to business_job_hiring_teams_path(@job)}
        else
          render :edit
        end
      end
    end
  end

  def promote
    @job = Job.find(params[:job_id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def client_jobs
    @client = Client.find(params[:client_id])
    @jobs = @client.open_jobs
    
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def search
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end
    if params[:status].present?
      where[:status] = params[:status] if params[:status].present?
    else
      where[:status] =  "open"
    end
    where[:company_id] = current_company.id
    where[:kind] = params[:kind] if params[:kind].present?
    where[:client_id] = params[:client_id] if params[:client_id].present? 

    @jobs = Job.search(query, where: where, fields: [:title]).to_a
  end

  def autocomplete
    if params[:query] == '' 
      query = "*"
    else
      query = params[:query]
    end

    @jobs = Job.search(query, where: {status: "open", company_id: current_company.id}, 
      fields: [{full_name: :word_start}])
    @job = Job.find(params[:job_id]) if params[:job_id].present?

    respond_to do |format|
      format.json { render json: @jobs.as_json(only: [:title, :id])}
      format.js {@jobs.to_a}
    end
  end

  private 

  def job_params
    params.require(:job).permit(:description, :recruiter_description, 
      :title, :location, :address, :benefits, :company_id,
      :client_id, :education_level, :function, :industry,
      :kind, :career_level, :status, :user_ids)
  end
end 