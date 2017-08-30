class Business::JobFeedsController < ApplicationController
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  include AuthHelper

  def index
    @job = Job.find(params[:job_id])
    @job_feed = @job.job_feed
  end

  def update 

    @feed = JobFeed.find(params[:id])
    @type = params[:job_feed].first.first
    respond_to do |format| 
      @feed.update(feed_params)
      format.js
    end
  end

  def edit
    @room = Room.find(params[:id])

    respond_to do |format|
      format.js
    end
  end



  private

  def render_errors(room)
    @errors = []
    room.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def feed_params
    params.require(:job_feed).permit(:adzuna, :trovit, :ziprecruiter, :indeed, :jobinventory)
  end
end