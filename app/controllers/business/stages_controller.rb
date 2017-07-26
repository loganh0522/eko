class Business::StagesController < ApplicationController 
  # filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index 
    @job = Job.find(params[:job_id])
    @stages = @job.stages
    @stage = Stage.new 
  end

  def new 
    @job = Job.find(params[:job_id])
    @stages = @job.stages.order("position")
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
      if @stage.save & @stage.update_attribute(:position, new_stage_position(@job))
        @stages = @job.stages.order("position")
      else
        render :new
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
        format.json { render json: @stage.errors.full_messages,
                                   status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stage = Stage.find(params[:id])
    @stage.destroy
    @job = Job.find(params[:job_id])
    
    @job.stages.each_with_index do |id, index| 
      Stage.update(id, {position: index + 1})
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

  def update_multiple
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @application = Application.find(id)
      @job = @application.apps
      
      if params[:stages] == "Rejected"
        @application.update_attribute(:rejected, true)
      else
        @application.update_attribute(:stage_id, params[:stages])  
      end    
    end

    # track_activity(@application, "move_stage")
    respond_to do |format|
      format.js
    end
  end


  private 

  def stage_params
    params.require(:stage).permit(:name, :position, :job_id)
  end

  def new_stage_position(job)
    job.stages.count
  end
end