class Business::TasksController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_taskable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_taskable, only: [:new]

  def index
    # @tasks = @taskable.all_tasks

    if params[:status] == 'complete'
      @tasks = @taskable.complete_tasks
    else
      @tasks = @taskable.open_tasks
    end
    # else
    #   if params[:status] == 'complete'
    #     @tasks = current_company.complete_tasks
    #   else
    #     @tasks = current_company.open_tasks
    #   end
    # end
    
    # @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @job = current_company.jobs.first
    # @interviews_by_date = @job.interviews.group_by(&:interview_date)
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
        if params[:task][:user_ids].present? 
          assigned_to(@new_task)
        end
        @tasks = @taskable.all_tasks
        track_activity @new_task
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
    respond_to do |format| 
      if params[:status].present?
        @task.update_attribute(:status, params[:status])
        track_activity @task, "complete"
      else
        @task.update(task_params)   
      end
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

  private 

  def task_params 
    params.require(:task).permit(:title, :notes, :kind, :due_date, :due_time, :status, :user_id, :company_id)
  end

  def assigned_to(task)
    user_ids = params[:task][:user_ids].split(',')
    user_ids.each do |id| 
      AssignedUser.create(assignable_type: "Task", assignable_id: task.id, user_id: id )
    end
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
    resource, id = request.path.split('/')[-4..-2]
    @taskable = resource.singularize.classify.constantize.find(id)
  end
end