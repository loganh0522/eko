class Business::StagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company

  def new 
    @job = Job.find(params[:job_id])
    @stages = @job.stages.order("position")
    @stage = Stage.new 
    @questionairre = @job.questionairre
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

    # respond_to do |format| 
    #   format.html 
    #   format.js 
    # end
  end

  def update
    @stage = Stage.find(params[:id])
    @job = Job.find(params[:job_id])

    respond_to do |format|
      if @stage.update(stage_params)
        format.json { head :no_content }
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
      format.html { redirect_to posts_url }
      format.json { head :no_content }
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
    params.require(:stage).permit(:name, :position, :job_id)
  end

  def new_stage_position(job)
    job.stages.count + 1
  end
end