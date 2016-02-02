class Business::ApplicationsController < ApplicationController
  def show 
    @user = User.find(params[:id])
    @job = Job.find(params[:job_id])
    @application = Application.where(user_id: params[:id], job_id: params[:job_id]).first
    @stage = @application.stage
    @positions = @user.work_experiences
    @comment = Comment.new
    @comments = @application.comments
  end

  def edit

  end

  def update

  end

  def move_stages 
    app = Application.find(params[:application_id])
    current_stage = app.stage
    next_stage = Stage.where(position: current_stage.position + 1, job_id: params[:job_id]).first
    app.update_attribute(:stage_id, next_stage.id)
    redirect_to :back
  end

  def reject

  end
end