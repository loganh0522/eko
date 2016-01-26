class Business::CustomersController < ApplicationController
  before_filter :belongs_to_company
  
  def index 

  end

  def new
    @customer = Customer.new
    @company = current_company
  end

  def create  
    @company = current_company
    customer = StripeWrapper::Customer.create(
      :company => @company,
      :card => params[:stripeToken]
      )   
    if customer.successful? 
      @customer.save
    end
     
  end

  private 

  # def customer_params
  #   params.require(:invitation).permit()
  # end
end