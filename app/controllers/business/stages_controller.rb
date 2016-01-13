class Business::StagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company

  def new 
    @job = Job.find(params[:job_id])
    @stages = @job.stages.order("position")
    @stage = Stage.new 
  end

  def create 
    @stage = Stage.new(stage_params)
    @job = Job.find(params[:job_id])  
    @stage.job = @job

    if @stage.save
      @stage.update_attribute(:position, new_stage_position(@job) )
      redirect_to new_business_job_stage_path(@job)
    else

      flash[:error] = "Sorry, something went wrong. Please try again."
      render :new
    end
  end

  def sort
    @job = Job.find(params[:job_id])
    params[:stage].each_with_index do |id, index|
      Stage.update(id, {position: index +1})
    end
    render nothing: true
  end

  private 

  def stage_params
    params.require(:stage).permit(:name, :position)
  end

  def new_stage_position(job)
    job.stages.count + 1
  end
end