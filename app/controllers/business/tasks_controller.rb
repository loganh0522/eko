class Business::TasksController < ApplicationController
  # filter_access_to :all
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_taskable, except: [:new, :destroy, :create_multiple, :completed]
  before_filter :new_taskable, only: [:new]

  def job_tasks
    @job = @taskable
    where = {}
    if params[:query].present? 
      query = params[:query] 
    else 
      query = "*"
    end   
    where[:client_id] = params[:client_id] if params[:client_id].present?
    where[:company_id] = current_company.id
    where[:status] = 'active'
    where[:kind] = params[:kind] if params[:kind].present?
    @tasks = Task.search(query, where: where).to_a

    respond_to do |format|
      format.js
      format.html
    end 
  end

  def index
    if params[:application_id].present?
      where = {}
      where[:taskable_id] = params[:application_id]
      where[:status] = 'active'
      where[:company_id] = current_company.id
      where[:kind] = params[:kind] if params[:kind].present?
      @tasks = Task.search("*", where: where).to_a
    else
      where = {}
      if params[:query].present? 
        query = params[:query] 
      else 
        query = "*"
      end   
      where[:client_id] = params[:client_id] if params[:client_id].present?
      where[:company_id] = current_company.id
      where[:status] = 'active'
      where[:kind] = params[:kind] if params[:kind].present?
      @tasks = Task.search(query, where: where).to_a
    end

    respond_to do |format|
      format.js
      format.html
    end 
  end

  def complete
    # @tasks = @taskable.complete_tasks

    where = {}
    where[:company_id] = current_company.id
    where[:kind] = params[:kind] if params[:kind].present? 
    @tasks = Task.search params[:query], where: where
  end

  def overdue
    @tasks = @taskable.overdue_tasks
  end

  def tasks_due_today
    @tasks = @taskable.due_today
  end

  def new 
    @task = Task.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @new_task = @taskable.tasks.build(task_params)
    @task = Task.new
    
    respond_to do |format| 
      if @new_task.save 
        @tasks = @taskable.open_tasks
        track_activity @new_task
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
    @task.update_attribute(:status, "complete")
    track_activity @task, "complete"

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.js
    end
  end

  def create_multiple
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @candidate = Candidate.find(id)
      if params[:job_id].present?
        @job = Job.find(params[:job_id])
        @application = Application.where(candidate_id: @candidate.id, job: @job.id).first
        @task = @application.tasks.build(title: params[:title],
          due_date: params[:due_date], due_time: params[:due_time],
          kind: params[:kind], notes: params[:notes],
          user_id: current_user.id, status: params[:status],
          company_id: current_company.id, user_ids: params[:user_ids])
      else 
        @task = @candidate.tasks.build(title: params[:title],
          due_date: params[:due_date], due_time: params[:due_time],
          kind: params[:kind], notes: params[:notes],
          user_id: current_user.id, status: params[:status],
          company_id: current_company.id, user_ids: params[:user_ids])
      end
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
      :due_date, :due_time, :status, 
      :user_ids, :candidate_ids, :job_id,
      :user_id, :company_id)
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
end