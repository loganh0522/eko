module StripeWrapper 
  class Charge 
    attr_reader :error_message, :response
    
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount], 
          currency: 'cdn', 
          card: options[:card], 
          description: options[:description]
          )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message) 
      end
    end

    def successful? 
      response.present?
    end
  end

  class StripeCustomer 
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        response = Stripe::Customer.create(
          card: options[:card],
          email: options[:company].name,
          plan: 'free'
        )
        new(response: response)
      rescue Stripe::CardError => e 
        new(error_message: e.message)
      end         
    end

    def self.edit_customer(options={})
      begin 
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        customer = Stripe::Customer.retrieve(options[:customer_id])
        customer.card = options[:card]
        customer.save
        new(response: customer)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def self.create_plan(options={})
      begin 
        Stripe.api_key = ENV['STRIPE_SECRET_KEY'] 
        response = Stripe::Subscription.create(
          customer: options[:customer_id],
          plan: options[:plan]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def self.update_plan(options={})
      begin 
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        customer = Stripe::Customer.retrieve(options[:customer_id])
        subscription = customer.subscriptions.retrieve(options[:subscription_id])
        subscription.plan = options[:plan]
        subscription.save
        new(response: customer)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def self.cancel_subscription(options={})
      begin 
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        customer = Stripe::Customer.retrieve(options[:customer_id])
        subscription = customer.subscriptions.retrieve(options[:subscription_id]).delete
        new(response: customer)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end



    def successful?
      response.present?
    end
  end

  # class Customer
  #   def self.create(user)
  #     if user.stripe_customer_id.blank?
  #       stripe_customer = Stripe::Customer.create(
  #         email: user.email
  #       )

  #       user.stripe_customer_id = stripe_customer.id
  #     else
  #       stripe_customer = Stripe::Customer.retrieve(user.stripe_customer_id)
  #     end

  #     stripe_customer
  #   end
end