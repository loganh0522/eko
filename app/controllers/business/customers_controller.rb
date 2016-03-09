class Business::CustomersController < ApplicationController
  before_filter :belongs_to_company
  
  def index 
    @customer = current_company.customer
  end

  def new
    @customer = Customer.new
    @company = current_company
  end

  def create  
    @company = current_company
    if !@company.customer.present? 
      customer = StripeWrapper::StripeCustomer.create(
        :company => @company,
        :card => params[:stripeToken]
        )   

      if customer.successful?
        stripe_customer = JSON.parse customer.response.to_s
        binding.pry
        Customer.create(company_id: current_company.id, 
          plan: stripe_customer['subscriptions']['data'].first['plan']['id'], 
          stripe_customer_id: stripe_customer["id"], 
          stripe_subscription_id: stripe_customer['subscriptions']['data'].first['id'], 
          last_four: stripe_customer['sources']['data'].first['last4'],
          exp_year: stripe_customer['sources']['data'].first['exp_year'],
          exp_month: stripe_customer['sources']['data'].first['exp_month'])
        redirect_to business_customers_path
      end
    else 
      render :index
      flash[:error] = "You have already created subscription."
    end
  end

  def edit 
    @customer = current_company.customer 
    @company = current_company
  end

  def update
    customer = StripeWrapper::StripeCustomer.edit_customer(
      :customer_id => current_company.customer.stripe_customer_id,
      :card => params[:stripeToken]
      )
    if customer.successful?
      current_company.customer.update_attribute(:plan, params[:plan])
      redirect_to business_customers_path
      flash[:success] = "Your billing information was successfully changed"
    end
  end

  def plan
    @plan = current_company.customer.plan
  end

  def update_plan 
    customer = StripeWrapper::StripeCustomer.update_plan(
      :customer_id => current_company.customer.stripe_customer_id,
      :subscription_id => current_company.customer.stripe_subscription_id,
      :plan => params[:plan]
      )
    if customer.successful?
      current_company.customer.update_attribute(:plan, params[:plan])
      redirect_to business_plan_path
      flash[:success] = "Your subscription was successful, the charge has been added to your card"
    end
  end

  def cancel 

  end

  def cancel_subscription
    customer = StripeWrapper::StripeCustomer.cancel_subscription(
      :customer_id => current_company.customer.stripe_customer_id,
      :subscription_id => current_company.customer.stripe_subscription_id,
      )
    if customer.successful? 
      current_company.customer.update_attribute(:plan, nil)
      redirect_to business_plan_path
      flash[:success] = "Your subscription was successfully canceled, your active job postings will close at the end of the billing period"
    end
  end

  private 

  # def customer_params
  #   params.require(:invitation).permit()
  # end
end