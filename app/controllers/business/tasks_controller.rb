class Business::TasksController < ApplicationController
  # filter_access_to :all
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_taskable, except: [:new, :destroy, 
    :job_complete, :job_overdue, :job_due_today, 
    :client_complete, :client_overdue, :client_due_today, 
    :create_multiple, :completed, :update, :new_multiple]
  before_filter :new_taskable, only: [:new]

  def job_tasks
    @job = Job.find(params[:job_id]) 
    @tasks = @job.open_tasks
  end

  def client_tasks
    @client = Client.find(params[:client_id]) 
    @tasks = @client.open_tasks
  end

  def index
    if params[:job].present?
      @candidate = Candidate.find(params[:candidate_id]) 
      @job = Job.find(params[:job])
      @tasks = @candidate.open_job_tasks(@job)
    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id]) 
      @tasks = @candidate.open_tasks
    else 
      @tasks = current_company.open_tasks
    end

    respond_to do |format|
      format.js
      format.html
    end 
  end

  def new 
    @task = Task.new
    @job = Job.find(params[:job]) if params[:job].present?
    @candidates = current_company.candidates.order(:created_at).limit(10)
    @users = current_company.users.limit(10)
    
    respond_to do |format|
      format.js
    end
  end

  def create 
    @user_ids = params[:task][:user_ids].split(',') 
    @candidate_ids = params[:task][:candidate_ids].split(',')
    create_tasks
  end

  def edit 
    @taskable = @taskable.taskable
    @task = Task.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @task = Task.find(params[:id])  
    @task.update(task_params)   

    respond_to do |format| 
      format.js
    end
  end

  def completed
    @task = Task.find(params[:id])
    @task.update_attributes(status: "complete", completed_by_id: current_user.id)
    track_activity @task, "complete"

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_multiple
    @task = Task.new
    @job = Job.find(params[:job]) if params[:job].present?

    respond_to do |format|
      format.js
    end
  end

  def create_multiple
    applicant_ids = params[:applicant_ids].split(',')
    @user_ids = params[:task][:user_ids].split(',') 

    applicant_ids.each do |id| 
      @candidate = Candidate.find(id)
      @task = @candidate.tasks.build(task_params.merge!(user_ids: @user_ids))
      @task.save
      # track_activity(@comment, "create")
    end
    
    respond_to do |format| 
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

    if params[:status].present? && params[:status] == 'today'
      where[:due_date] = {gte: Time.now - 1.day, lte: Time.now + 1.day}
    elsif params[:status].present? && params[:status] == 'overdue'
      where[:due_date] = {lte: Time.now - 1.day}
    elsif params[:status].present?
      where[:status] = params[:status]
    else
      where[:status] = 'active' 
    end

    where[:company_id] = current_company.id
    where[:users] = {all: [current_user.id]} if params[:owner] == "user"
    where[:users] = {all: [params[:assigned_to]]} if params[:assigned_to].present?
    where[:job_id] = params[:job_id] if params[:job_id].present?
    where[:taskable_id] = params[:candidate_id] if params[:candidate_id].present? 
    where[:taskable_type] = params[:type] if params[:type].present?
    where[:client_id] = params[:client_id] if params[:client_id].present?
    where[:kind] = params[:kind] if params[:kind].present?

    @tasks = Task.search(query, where: where)
  end

  private 

  def task_params 
    params.require(:task).permit(:title, :notes, :kind, 
      :due_date, :due_time, :status, :candidate_ids, :job_id,
      :user_id, :company_id
      )
  end

  def load_taskable
    if request.path.split('/')[-3..-1][1] == "business" || request.path.split('/')[-3..-1][0] == "business"
      @taskable = current_company
    else
      resource, id = request.path.split('/')[-3..-1]
      @taskable = resource.singularize.classify.constantize.find(id)
    end
  end

  def new_taskable
    if request.path.split('/')[-3..-1][0] == "business" 
      @taskable = current_company
    else
      resource, id = request.path.split('/')[-4..-2]
      @taskable = resource.singularize.classify.constantize.find(id)
    end
  end

  def render_errors(task)
    @errors = []
    task.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def create_tasks 
    respond_to do |format| 
      if @candidate_ids.length >= 1 && params[:task][:job_id].present?
        
        @candidate_ids.each do |id| 
          @candidate = Candidate.find(id)
          @task = @candidate.tasks.build(task_params.merge!(user_ids: @user_ids)).save
        end

        @tasks = Task.where(job_id: params[:task][:job_id], status: "active")
        format.js
      else 
        @new_task = @taskable.tasks.build(task_params.merge!(user_ids: @user_ids))
        
        if @new_task.save      
          if @taskable.class == Job
            @tasks = @taskable.open_tasks
          elsif @taskable.class == Candidate && params[:task][:job_id].present?
            @job = Job.find(params[:task][:job_id])
            @tasks = @taskable.open_job_tasks(@job)
          elsif @taskable.class == Candidate
            @tasks = @taskable.open_tasks
          elsif @taskable.class == Company
            @tasks = current_company.open_tasks
          end
          format.js 
        else
          render_errors(@new_task)
          format.js 
        end
      end
    end
  end
end







