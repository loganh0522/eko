class Business::OrderItemsController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  include AuthHelper


  def new 

    @board = PremiumBoard.find(params[:board])

    @order_item = OrderItem.new
  
  end


  def create
    @order = Order.new(order_params)
    respond_to do |format| 
      if @order.save 
        format.js
      end
    end
  end

  def index 

  end


  private

  def render_errors(room)
    @errors = []
    room.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def order_params 
    params.require(:scorecard).permit(:job_id, :user_id, :company_id,
      :total, :tax, 
      order_items_attributes: [:id, :premium_board_id, 
        :_destroy, :total])
  end
end