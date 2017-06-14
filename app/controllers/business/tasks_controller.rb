class Business::TasksController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_taskable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_taskable, only: [:new]

  def index
    @tasks = current_company.tasks
    # @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @job = current_company.jobs.first
    # @interviews_by_date = @job.interviews.group_by(&:interview_date)

    respond_to do |format|
      format.js
    end 
  end

  def new 
    @task = Task.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @task = @taskable.tasks.build(task_params)

    respond_to do |format| 
      if @task.save 
        format.js 
      end
    end
  end

  def edit 
    @task = Task.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format| 
      if @task.update(comment_params)
        format.js
      end
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
    params.require(:task).permit(:title, :notes, :user_id)
  end

  def load_taskable
    resource, id = request.path.split('/')[-3..-1]
    @taskable = resource.singularize.classify.constantize.find(id)
  end

  def new_taskable
    resource, id = request.path.split('/')[-4..-2]
    @taskable = resource.singularize.classify.constantize.find(id)
  end
end