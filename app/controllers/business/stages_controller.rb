class Business::StagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company

  def new 
    binding.pry
    @job = Job.find(params[:job_id])
    @stage = Stage.new
  end

  def create

  end

  def edit 

  end

  def update

  end

end