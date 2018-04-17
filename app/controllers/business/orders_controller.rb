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
      charge = charge.response    

      @order = Order.new(order_params.merge!(
        stripe_id: charge.id,
        title: "Job Advertising",
        tax_amount: @taxAmount,
        tax_percentage: 0.13,
        last_four: charge.source.last4, 
        card_brand: charge.source.brand,
        card_exp_month: charge.source.exp_month, 
        card_exp_year: charge.source.exp_year,
        total: @totalPrice, 
        subtotal: @subTotal
        ))
      
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

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html
      format.json  
      format.pdf {
        send_data(@order.receipt.render,
          filename: "#{@order.created_at.strftime("%Y-%m-%d")}-talentwiz-receipt.pdf",
          type: "application/pdf",
          disposition: :inline
          )
      }
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
    @taxAmount = @subTotal * 0.13

    return @totalPrice, @subTotal, @taxAmount
  end

  def order_params 
    params.require(:order).permit(:job_id, :user_id, :company_id,
      :total, :tax, :subtotal, :stripe_id, :title, :tax_amount, :tax_percentage, :last_four, 
      :card_brand, :card_exp_year, :card_exp_month,
      order_items_attributes: [:id, :premium_board_id, 
        :_destroy, :unit_price, :posting_duration_id])
  end
end


  
