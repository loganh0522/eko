class Business::TasksController < ApplicationController
  # filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_taskable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_taskable, only: [:new]

  def index
    if params[:status] == 'complete'
      @tasks = @taskable.complete_tasks
    else
      @tasks = @taskable.open_tasks
    end
    
    respond_to do |format|
      format.js
      format.html
    end 
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
    
    if params[:status].present?
      @task.update_attribute(:status, params[:status])
      @tasks = @task.taskable.tasks 
      track_activity @task, "complete"
    else
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

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
    if request.path.split('/')[-3..-1][1] == "business"
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