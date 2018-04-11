class Business::OrdersController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new 
    @board = PremiumBoard.find(params[:board])
    @order_item = OrderItem.new
  end


  def create
    order_item_total(params[:order][:order_items_attributes])
    

    charge = StripeWrapper::Charge.create(
      :customer_id => current_company.customer.stripe_customer_id,
      :amount => @totalPrice.to_i
      )

    if charge.successful?
      @order = Order.new(order_params.merge!(total: @totalPrice, subtotal: @subTotal, tax: 0.13))
      
      respond_to do |format|
        if @order.save 
          format.js
        else
          render_errors(@order)
          format.js
        end
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

  def order_item_total(items)
    @subTotal = 0 
    @totalPrice = 0 

    items.each do |item| 
      @duration = PostingDuration.find(item[1][:posting_duration_id])
      @job_board = PremiumBoard.find(item[1][:premium_board_id])
      
      if @duration.price == item[1][:unit_price].to_i && @duration.premium_board == @job_board
        @subTotal += @duration.real_price * 100
      end
    end
    
    @totalPrice = @subTotal * 1.13

    return @totalPrice, @subTotal 
  end

  def order_params 
    params.require(:order).permit(:job_id, :user_id, :company_id,
      :total, :tax, :subtotal,
      order_items_attributes: [:id, :premium_board_id, 
        :_destroy, :unit_price, :posting_duration_id])
  end
end