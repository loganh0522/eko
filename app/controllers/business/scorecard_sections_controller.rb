class Business::ScorecardSectionsController < ApplicationController
  def new
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:scorecard_id])
    @section = ScorecardSection.new
    respond_to do |format|
      format.js 
    end
  end

  def create 
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:scorecard_id])
    @section = ScorecardSection.new(s_params)

    respond_to do |format| 
      if @section.save
        @sections = @scorecard.scorecard_sections
        format.js 
      else 
        flash[:danger] = "Something went wrong, please try again."
      end
    end  
  end

  def edit
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:scorecard_id])
    @section = ScorecardSection.find(params[:id])
  end

  def update
    @job = Job.find(params[:job_id])
    @scorecard = Scorecard.find(params[:scorecard_id])
    @section = ScorecardSection.find(params[:id])

    respond_to do |format|
      if @section.update(s_params)
        @sections = @scorecard.scorecard_sections
        format.js
      else
        flash[:danger] = "Sorry something went wrong"
      end
    end
  end

  def destroy
    @section = ScorecardSection.find(params[:id])  
    @section.destroy  
    respond_to do |format|
      format.js 
    end
  end

  private

  def s_params 
    params.require(:scorecard_section).permit(:scorecard_id, :id, :body, section_options_attributes:[:id, :body, :_destroy])
  end
end