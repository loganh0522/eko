class Business::StageActionsController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    @stage_actions = @job.stage_actions
  end
  
  def new
    @stage_action = StageAction.new
    @stage = Stage.find(params[:stage])
    @users = @stage.job.users
    respond_to do |format|
      format.js 
    end
  end

  def create
    @stage_action = StageAction.new(action_params)
    @user_ids = params[:stage_action][:user_ids].split(',') 

    respond_to do |format| 
      if @stage_action.save
        @stage = @stage_action.stage
      else 
        render_errors(@stage_action)
      end
      format.js
    end  
  end

  def edit
    @stage_action = StageAction.find(params[:id])
    @stage = @stage_action.stage
    @users = @stage_action.stage.job.users
    respond_to do |format|
      format.js 
    end
  end

  def update
    @stage_action = StageAction.find(params[:id])
    @stage = @stage_action.stage

    respond_to do |format|
      if @stage_action.update(action_params)
        @stage_actions = @stage.stage_actions
      else
        render_errors(@stage_action)
      end
      format.js
    end
  end

  def show 
    @job = Job.find(params[:job_id])
    @stage_actions = @job.stage_actions
  end

  def destroy
    @stage_action = StageAction.find(params[:id])  
    @stage_action.destroy  
    
    respond_to do |format|
      format.js 
    end
  end

  private

  def action_params 
    params.require(:stage_action).permit(:stage_id, :interview_kit_id, :automate, :kind,
      :message, :subject, :name, :assigned_to,
      user_ids: [])
  end

  def render_errors(stage_action)
    @errors = []
    stage_action.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end