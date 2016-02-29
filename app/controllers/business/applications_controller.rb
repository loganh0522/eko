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

  def update_multiple
    @job = Job.find(params[:job_id])
    applicant_ids = params[:applicant_ids].split(',')
    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      @application.update_attribute(:stage_id, params[:stage][:stage_id])
    end
    redirect_to business_job_path(@job)
  end

  def add_note_multiple 
    binding.pry
    @job = Job.find(params[:job_id])  
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      Comment.create(body: params[:comment], user_id: current_user.id, application_id: @application.id)
    end

    redirect_to business_job_path(@job)
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