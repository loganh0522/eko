class Business::JobsController < ApplicationController
  layout "business"
  include AmazonSignature
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :owned_by_company, only: [:edit, :show, :update]
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index, :show, :destroy]
  

  def index
    if current_company.subsidiaries.present?
      @jobs = current_company.active_subsidiary_jobs
    else 
      @jobs = current_company.active_jobs.accessible_by(current_ability)
    end

    respond_to do |format|
      format.html
    end
  end

  def new
    @job = Job.new

  end

  def create 
    @job = Job.new(job_params.merge!(company: current_company, status: 'open', is_active: true))  
    

    if @job.save 
      track_activity @job, 'create', current_company.id, nil, @job 

      redirect_to business_job_questions_path(@job)
    else
      render :new 
    end
  end

  def edit
    @job = Job.find(params[:id])

    # aws_config = {
    #   accessKey: ENV['AWS_ACCESS_KEY_ID'],
    #   secretKey: ENV['AWS_SECRET_ACCESS_KEY'],
    #   bucket: ENV['S3_BUCKET_NAME'],
    #   region: ENV['AWS_REGION'],
    #   acl:  'public-read',
    #   key_start: 'uploads'
    # }

    # @aws_data = FroalaEditorSDK::S3.data_hash(aws_config)
    # @hash = AmazonSignature::data_hash

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @job = Job.find(params[:id])
    # @hash = AmazonSignature::data_hash
    
    if params[:status].present? 
      if params[:status] == "open" || params[:status] == "closed"
        @job.update(status: params[:status])
      
      elsif params[:status] == "true" || params[:status] == "false"
        if params[:status] == "true"
          @job.update(is_active: true)
        else
          @job.update(is_active: false)
        end
      end

      respond_to do |format|
        format.js
      end
    else
      if @job.update(job_params)
        redirect_to business_job_questions_path(@job)
      else
        render :edit
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

    @jobs = Job.accessible_by(current_ability).search(query, where: where, fields: [:title], match: :word_start)
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