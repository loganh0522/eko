class Business::StagesController < ApplicationController 
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index 
    @job = Job.find(params[:job_id])
    @stages = @job.stages
  end

  def new 
    @job = Job.find(params[:job_id])
    @stage = Stage.new 

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def create 
    @stage = Stage.new(stage_params)
    @job = Job.find(params[:job_id])  
    
    respond_to do |format| 
      if @stage.save && @stage.update_attribute(:position, new_stage_position(@job))
        @stages = @job.stages.order("position")
      else
        render_errors(@stage)
      end
      format.js
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
        render_errors(@stage)
        format.js
      end
    end
  end

  def destroy
    @stage = Stage.find(params[:id])
    @stage.destroy
    @job = Job.find(params[:job_id])
    
    @job.stages.each_with_index do |stage, index| 
      stage.update_attributes(position: index + 1)
    end

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


  private 

  def stage_params
    params.require(:stage).permit(:name, :position, :job_id)
  end

  def new_stage_position(job)
    job.stages.count
  end

  def render_errors(stage)
    @errors = []

    stage.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end