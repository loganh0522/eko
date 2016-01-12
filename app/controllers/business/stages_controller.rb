class Business::StagesController < ApplicationController 

  def new 
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