class JobPostingsController < ApplicationController

  def index
    @jobs = JobPosting.all
  end

  def new
    @job_posting = JobPosting.new
  end

  def create 
    @job_posting = JobPosting.new(job_params)

    if @job_posting.save 
      flash[:notice] = "Your job posting #{@job_posting.title}, was created"
      redirect_to :root
    else
      render :new
    end
  end

  private 
    def job_params
      params.require(:job_posting).permit(:description, :title, :city, :country, :province, :benefits)
    end
end 