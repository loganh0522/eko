class Business::JobFeedsController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :create_cart
  include AuthHelper

  def index
    if params[:type] == "free"
      @job = Job.find(params[:job_id])
      @job_feed = @job.job_feed
    elsif params[:type] == "premium-job-boards"
      @job = Job.find(params[:job_id])
      @job_feed = @job.job_feed
      @job_feeds = PremiumBoard.all
      @order_item = OrderItem.new
      @order = Order.new
      # @order_items = OrderItem.all
    end

    respond_to do |format| 
      format.js
      format.html
    end
  end

  def premium

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

  def create_cart
    @order = Order.new
  end

  def feed_params
    params.require(:job_feed).permit(:adzuna, :trovit, :ziprecruiter, :indeed, :jobinventory)
  end
end