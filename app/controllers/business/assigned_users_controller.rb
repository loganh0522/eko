class Business::AssignedUserController < ApplicationController
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_taskable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_taskable, only: [:new]
  
  
  def index
    @company_users = current_company.users.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
    render :json => @company_users.to_json 
  end

  def new
    @assign_to = AssignedUser.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @assignable = @assignable.tasks.build(task_params)
    @assign_to = AssignedUser.new

    respond_to do |format| 
      if @new_task.save 
        @tasks = @taskable.all_tasks
        format.js 
      end
    end
  end

  def edit 
    @assignable = AssignedUser.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @assignable = AssignedUser.find(params[:id])

    respond_to do |format| 
      if @task.update(comment_params)
        format.js
      end
    end
  end

  def destroy
    @assignable = AssignedUser.find(params[:id])
    @assignable = 

    respond_to do |format|
      format.js
    end
  end

  private 

  def task_params 
    params.require(:task).permit(:title, :notes, :due_date, :due_time, :user_id, :company_id)
  end

  def load_assignable
    if request.format == 'text/html'
      @taskable = current_company
    else
      resource, id = request.path.split('/')[-3..-1]
      @assignable = resource.singularize.classify.constantize.find(id)
    end
  end

  def new_assignable
    resource, id = request.path.split('/')[-4..-2]
    @assignable = resource.singularize.classify.constantize.find(id)
  end