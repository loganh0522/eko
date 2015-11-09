class JobPostingsController < ApplicationController

  def index
    @jobs = JobPosting.all
    @job = JobPosting.find_by(params[:id])
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

  def edit
    @job_posting = JobPosting.find(params[:id])
  end

  def update
    @job_posting = JobPosting.new(job_params)

    if @job_posting.update(job_params)
      flash[:notice] = "#{@job_posting.title} has been updated"
      redirect_to :root
    else
      render :edit
    end
  end

  private 
    def job_params
      params.require(:job_posting).permit(:description, :title, :city, :country, :province, :benefits)
    end
end 