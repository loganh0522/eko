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
    
    if params[:stage].present?
      @stage = Stage.find(params[:stage]) 
      @job = @stage.job
      @users = @stage.job.users
    else
      @standard_stage = params[:standard] 
      @job = Job.find(params[:job])
      @users = @job.users
    end
    
    respond_to do |format|
      format.js 
    end
  end

  def create
    @user_ids = params[:stage_action][:user_ids].split(',') if params[:stage_action][:user_ids].present?
    @stage_action = StageAction.new(action_params.merge!(user_ids: @user_ids))

    respond_to do |format| 
      if @stage_action.save
        if @stage_action.standard_stage == nil
          @stage = @stage_action.stage if @stage_action.stage.present?
        else
          @standard_stage = @stage_action.standard_stage 
          @job = @stage_action.job
        end
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
    @job = @stage.job

    
    respond_to do |format|
      format.js 
    end
  end

  def update
    @user_ids = params[:stage_action][:user_ids].split(',') if params[:stage_action][:user_ids].present?
    @stage_action = StageAction.find(params[:id])
    @stage = @stage_action.stage

    respond_to do |format|
      if @stage_action.update(action_params.merge!(user_ids: @user_ids))
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
    params.require(:stage_action).permit(:stage_id, :automate, :kind,
      :message, :subject, :name, :assigned_to, :position, :standard_stage, :job_id, :interview_kit_template_id,
      user_ids: [])
  end

  def render_errors(stage_action)
    @errors = []

    stage_action.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end