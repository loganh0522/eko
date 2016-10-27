class Business::StagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?

  def new 
    @job = Job.find(params[:job_id])
    @stages = @job.stages.order("position")
    @stage = Stage.new 
    @questionairre = @job.questionairre
    @scorecard = @job.scorecard
  end

  def create 
    @stage = Stage.new(stage_params)
    @job = Job.find(params[:job_id])  
    @stages = @job.stages.order("position")

    respond_to do |format| 
      if @stage.save & @stage.update_attribute(:position, new_stage_position(@job))
        format.html {redirect_to new_business_job_stage_path(@job)}
        format.js
      else
        flash[:error] = "Sorry, something went wrong. Please try again."
        render :new
      end
    end
  end

  def edit
    @stage = Stage.find(params[:id])
    @job = Job.find(params[:job_id])
  end

  def update
    @stage = Stage.find(params[:id])
    @job = Job.find(params[:job_id])

    respond_to do |format|
      if @stage.update(stage_params)
        format.js
      else
        format.json { render json: @stage.errors.full_messages,
                                   status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stage = Stage.find(params[:id])
    @job = Job.find(params[:job_id])
    @stage.destroy

    respond_to do |format|
      format.js
    end
  end

  def sort
    @job = Job.find(params[:job_id])
    params[:stage].each_with_index do |id, index|
      Stage.update(id, {position: index + 1})
    end
    render nothing: true
  end

  def update_multiple
    @job = Job.find(params[:job_id])
    
    applicant_ids = params[:applicant_ids].split(',')

    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      @application.update_attribute(:stage_id, params[:stage][:stage_id])
      track_activity(@application, "move_stage")
    end
    redirect_to business_job_path(@job)
  end

  def move_stages 
    @app = Application.find(params[:application_id])
    current_stage = app.stage
    @next_stage = Stage.where(position: current_stage.position + 1, job_id: params[:job_id]).first
    
    if @app.update_attribute(:stage_id, @next_stage.id)
      track_activity(@app, "move_stage")
      redirect_to :back
    else
      flash[:danger] = "Sorry, something went wrong please try again."
      redirect_to :back
    end
  end

  private 

  def stage_params
    params.require(:stage).permit(:name, :position, :job_id)
  end

  def new_stage_position(job)
    job.stages.count + 1
  end
end