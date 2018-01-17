class Admin::CompaniesController < ApplicationController
  layout "admin"
  before_filter :require_user
 
  def index
    @companies = Company.all
    
    respond_to do |format|
      format.html
    end
  end

  def new
    @company = Company.new
  end

  def create 
    @company = Company.new

    if @job.save && @job.company == current_company
      redirect_to business_job_hiring_teams_path(@job)
    else
      render :new
    end
  end

  def show 
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
      flash[:notice] = "#{@job.title} has been updated"
      redirect_to business_job_hiring_teams_path(@job)
    else
      render :edit
    end
  end

  def destroy

  end

  def verified
    @company = Company.find(params[:id])
    @company.update_attributes(verified: true)
    
    respond_to do |format|
      format.js
    end
  end

  def autocomplete
    render :json => Job.search(params[:term], where: {company_id: current_company.id}, 
      fields: [{title: :word_start}])
  end

  private 
end 