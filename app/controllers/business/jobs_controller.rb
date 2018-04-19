class Business::JobsController < ApplicationController
  layout "business"
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index, :show, :destroy]
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company, only: [:edit, :show, :update]

  def index
    @jobs = current_company.active_jobs.accessible_by(current_ability)

    respond_to do |format|
      format.html
    end
  end

  def new
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params.merge!(status: 'open', is_active: true))  

    if @job.save 
      redirect_to business_job_questions_path(@job)
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
        if params[:status] == "open" || params[:status] == "closed"
          @job.update(status: params[:status])
          format.js
        elsif params[:status] == "true" || params[:status] == "false"
          if params[:status] == "true"
            @job.update(is_active: true)
          else
            @job.update(is_active: false)
          end
          format.js
        else 
          redirect_to :back
          flash[:danger] = "Something went wrong, please try again."
        end
      else
        if @job.update(job_params)
          format.html {redirect_to business_job_questions_path(@job)}
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

    if params[:is_active].present?
      if params[:is_active] == 'true'
        where[:is_active] = true
      else
        where[:is_active] = false
      end
    else 
      where[:is_active] = true
    end


    where[:status] = params[:status] if params[:status].present?
    where[:company_id] = current_company.id
    where[:users] = [current_user.id] if params[:owner] == "user"
    where[:kind] = params[:kind] if params[:kind].present?
    where[:client_id] = params[:client_id] if params[:client_id].present? 

    @jobs = Job.search(query, where: where, fields: [:title], match: :word_start).records.accessible_by(current_ability)
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
      :title, :location, :address, :benefits, :company_id, :is_active,
      :client_id, :education_level, :function, :industry, :start_salaray, :end_salary,
      :kind, :career_level, :status, :user_ids)
  end
end 