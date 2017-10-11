class Business::OrdersController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new 
    @board = PremiumBoard.find(params[:board])
    @order_item = OrderItem.new
  end


  def create
    customer = StripeWrapper::Charge.create(
      :customer_id => current_company.customer.stripe_customer_id,
      :amount => (params[:order][:total].to_f * 100).to_i
      )
    
    if customer.successful?
      @order = Order.new(order_params)
      respond_to do |format| 
        if @order.save 
          format.js
        else
          format.js
        end
      end
    else 
      format.js
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
    params.require(:order).permit(:job_id, :user_id, :company_id,
      :total, :tax, 
      order_items_attributes: [:id, :premium_board_id, 
        :_destroy, :total])
  end
end