class Business::CustomersController < ApplicationController
  before_filter :require_user
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

        company_subscription(params[:plan])

        Customer.create(company_id: current_company.id, 
          stripe_customer_id: stripe_customer["id"],  
          last_four: stripe_customer['sources']['data'].first['last4'],
          exp_year: stripe_customer['sources']['data'].first['exp_year'],
          exp_month: stripe_customer['sources']['data'].first['exp_month'])
      end
    else 
      render :index
      flash[:error] = "You have already created subscription."
    end
    redirect_to business_customers_path
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
      stripe_customer = JSON.parse customer.response.to_s
      current_company.customer.update( 
        last_four: stripe_customer['sources']['data'].first['last4'],
        exp_year: stripe_customer['sources']['data'].first['exp_year'],
        exp_month: stripe_customer['sources']['data'].first['exp_month'])
    else
      error = JSON.parse(customer.to_json)["error_message"]
      flash[:danger] = "#{error}. Please update your credit card information."
    end
    redirect_to business_customers_path
  end

  def new_plan
    redirect_to new_business_customer_path
    flash[:danger] = "Please complete your billing information before selecting a plan"
  end

  def plan
    @customer = current_company.customer
  end

  def create_plan
    customer = StripeWrapper::StripeCustomer.create_plan(
      :customer_id => current_company.customer.stripe_customer_id,
      :plan => params[:plan]
      )

    if customer.successful?
      stripe_customer = JSON.parse customer.response.to_s
      company_subscription(params[:plan])
      current_company.customer.update_attribute(:plan, stripe_customer['plan']['id'])     
      current_company.customer.update_attribute(:stripe_subscription_id, stripe_customer['id'])

      
      redirect_to business_plan_path
      flash[:success] = "Your subscription was successful, the charge has been added to your card"  
    else 
      error = JSON.parse(customer.to_json)["error_message"]
      flash[:danger] = "#{error}. Please update your credit card information."
      redirect_to business_plan_path
    end
  end

  def update_plan 
    customer = StripeWrapper::StripeCustomer.update_plan(
      :customer_id => current_company.customer.stripe_customer_id,
      :subscription_id => current_company.customer.stripe_subscription_id,
      :plan => params[:plan]
      )
    if customer.successful?
      company_subscription(params[:plan])
      current_company.customer.update_attribute(:plan, params[:plan])
      redirect_to business_plan_path
      flash[:success] = "Your subscription was successful, the charge has been added to your card"
    else 
      error = JSON.parse(customer.to_json)["error_message"]
      flash[:danger] = "#{error} Please update your credit card information."
      redirect_to business_plan_path
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
      current_company.customer.update_attribute(:stripe_subscription_id, nil)
      redirect_to business_plan_path
      flash[:success] = "Your subscription was successfully canceled, your active job postings will close at the end of the billing period"
    else 
      redirect_to business_plan_path  
    end
  end

  private 

  def company_subscription(plan)
    @company = current_company
    @plan = plan

    if @plan == 'start_up_month' || @plan == 'start_up_year'
      @company.update_column(:subscription, "start_up")
    elsif @plan == 'basic_month' || @plan == 'basic_year'
      @company.update_column(:subscription, "basic")
    elsif @plan == 'team_month' || @plan == 'team_year'
      @company.update_column(:subscription, "team")
    elsif @plan == 'plus_month' || @plan == 'plus_year'
      @company.update_column(:subscription, "plus")
    elsif @plan == 'growth_month' || @plan == 'growth_year'
      @company.update_column(:subscription, "growth")
    elsif @plan == 'enterprise_month' || @plan == 'enterprise_year'
      @company.update_column(:subscription, "enterprise")
    end
  end

  # def customer_params
  #   params.require(:invitation).permit()
  # end
end