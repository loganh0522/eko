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

    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   

    where[:job_id] = params[:job_id]
    where[:client_id] = params[:client_id] if params[:client_id].present?
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:users] = {all: [params[:assigned_to]]} if params[:assigned_to].present?
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a

    respond_to do |format|
      format.js
      format.html
    end 
  end

  def job_complete
    @job = Job.find(params[:job_id]) 
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   
    where[:company_id] = current_company.id
    where[:status] = 'complete'
    where[:job_id] = @job.id 
    where[:users] = {all: [params[:assigned_to]]} if params[:assigned_to].present?
    where[:kind] = params[:kind] if params[:kind].present?
    where[:users] = params[:owner] if params[:owner].present?

    @tasks = Task.search(query, where: where).to_a
  end

  def job_due_today
    @job = Job.find(params[:job_id]) 
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:job_id] = @job.id 
    where[:due_date] = {gte: Time.now - 1.day, }
    where[:kind] = params[:kind] if params[:kind].present?
    where[:users] = params[:owner] if params[:owner].present?
    where[:users] = {all: [params[:assigned_to]]} if params[:assigned_to].present?
    @tasks = Task.search(query, where: where).to_a
  end

  def job_overdue
    @job = Job.find(params[:job_id]) 
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end 
    where[:users] = {all: [params[:assigned_to]]} if params[:assigned_to].present?
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:job_id] = @job.id 
    where[:due_date] = {lte: Time.now}
    where[:users] = {all: [current_user.id]} if params[:owner] == "user"
    where[:taskable_type] = params[:type] if params[:type].present?
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a
  end

  def index
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end 
    
    if params[:application_id].present?
      @candidate = Application.find(params[:application_id]).candidate.id
      where[:taskable_id] = @candidate 
    else 
      where[:taskable_id] = params[:candidate_id]
    end

    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:users] = {all: [current_user.id]} if params[:owner] == "user"
    where[:users] = {all: [params[:assigned_to]]} if params[:assigned_to].present?
    where[:job_id] = params[:job_id] if params[:job_id].present?

    where[:taskable_type] = params[:type] if params[:type].present?

    where[:client_id] = params[:client_id] if params[:client_id].present?
    where[:kind] = params[:kind] if params[:kind].present?
    
    @tasks = Task.search(query, where: where, order: {created_at: :desc}).to_a


    respond_to do |format|
      format.js
      format.html
    end 
  end

  def complete
    # @tasks = @taskable.complete_tasks
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end 
    where[:company_id] = current_company.id
    where[:status] = 'complete'
    where[:kind] = params[:kind] if params[:kind].present?
    where[:users] = params[:owner] if params[:owner].present?
    
    @tasks = Task.search("*", where: where)
  end

  def overdue
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end 
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:due_date] = {lte: Time.now - 1.day}
    where[:users] = {all: [current_user.id]} if params[:owner] == "user"
    where[:taskable_type] = params[:type] if params[:type].present?
    where[:client_id] = params[:client_id] if params[:client_id].present?
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a
  end

  def tasks_due_today
    where = {}

    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end 

    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:due_date] = {gte: Time.now - 1.day, lte: Time.now + 1.day}
    where[:users] = {all: params[:owner]} if params[:owner].present?
    where[:taskable_type] = params[:type] if params[:type].present?
    where[:client_id] = params[:client_id] if params[:client_id].present?
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a
  end


  def client_tasks
    @client = Client.find(params[:client_id]) 

    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   

    where[:taskable_type] = "Client" 
    where[:taskable_id] = params[:client_id]
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a

    respond_to do |format|
      format.js
      format.html
    end 
  end

  def client_complete
    @client = Client.find(params[:client_id]) 
    
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   
    
    where[:company_id] = current_company.id
    where[:status] = 'complete'
    where[:taskable_type] = "Client" 
    where[:taskable_id] = params[:client_id]
    where[:kind] = params[:kind] if params[:kind].present?
    where[:users] = params[:owner] if params[:owner].present?

    @tasks = Task.search(query, where: where).to_a
  end

  def client_due_today
    @client = Client.find(params[:client_id]) 
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:taskable_type] = "Client" 
    where[:taskable_id] = params[:client_id]
    where[:kind] = params[:kind] if params[:kind].present?
    where[:users] = params[:owner] if params[:owner].present?

    @tasks = Task.search(query, where: where).to_a
  end

  def client_overdue
    @client = Client.find(params[:client_id]) 
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end 
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:taskable_type] = "Client" 
    where[:taskable_id] = params[:client_id]
    where[:due_date] = {lte: Time.now}
    where[:users] = {all: [current_user.id]} if params[:owner] == "user"
    where[:taskable_type] = params[:type] if params[:type].present?
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a
  end

  def new 
    @task = Task.new

    if @taskable.class == Application 
      @job = @taskable.job
      @taskable = @taskable.candidate
    end

    respond_to do |format|
      format.js
    end
  end

  def create 
    @user_ids = params[:task][:user_ids].split(',') 
    @candidate_ids = params[:task][:candidate_ids].split(',')
    create_tasks

    respond_to do |format| 
      if @new_task.save        
        if @taskable.class == Job
          @tasks = Task.where(job_id: @taskable.id, status: "active") 
        elsif @taskable.class == Candidate && params[:task][:job_id].present?
          @tasks = Task.where(job_id: params[:task][:job_id].to_i, 
            taskable_type: "Candidate", taskable_id: @new_task.taskable_id, status: "active")
        elsif @taskable.class == Candidate
          @tasks = Task.where(taskable_type: "Candidate", 
            taskable_id: @new_task.taskable_id, status: "active")
        end
        format.js 
      else
        render_errors(@new_task)
        format.js 
      end
    end
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

  def show 

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
    end
    # track_activity(@comment, "create")
    
    respond_to do |format| 
      format.js
    end
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
    if @candidate_ids.length >= 1 && params[:task][:job_id].present?
      @candidate_ids.each do |id| 
        @candidate = Candidate.find(id)
        @task = @candidate.tasks.build(task_params.merge!(user_ids: @user_ids)).save
      end
    else 
      @new_task = @taskable.tasks.build(task_params.merge!(user_ids: @user_ids))
    end
  end
end







