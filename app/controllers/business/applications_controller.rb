class Business::ApplicationsController < ApplicationController
  
  def index
    @job = Job.find(params[:job_id])
    @applicants = @job.applicants
    @stages = @job.stages
  end

  def show 
    @application = Application.find(params[:id])
    @user = @application.applicant
    @job = Job.find(params[:job_id])
    @stage = @application.stage
    @positions = @user.work_experiences
    @comment = Comment.new 
  end

  def edit

  end

  def update

  end

  def move_multiple
    @applications = Application.find(params[:application_ids])
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