class Business::CustomersController < ApplicationController

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
    binding.pry
    if customer.successful? 
      @customer.save
    end
     
  end

  private 

  # def customer_params
  #   params.require(:invitation).permit()
  # end
end