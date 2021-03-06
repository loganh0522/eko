class Business::ResumesController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
    @candidate = Candidate.find(params[:candidate_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @resume = Resume.new(resume_params)

    respond_to do |format|
      if @resume.save
        format.js 
      else
        @error = "Must be PDF file."
        format.js 
      end
    end
  end

  def show 
    @candidate = Candidate.find(params[:candidate_id])
    @resume = @candidate.resumes.first

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @resume = Resume.find(params[:id])
    @resume.destroy
    redirect_to resumes_path, notice:  "The resume #{@resume.name} has been deleted."
  end

private
  def resume_params
    params.require(:resume).permit(:name, :candidate_id)
  end
end