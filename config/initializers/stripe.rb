require "stripe"

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    customer = Customer.where(stripe_customer_id: event.data.object.customer).first
    company = customer.company
    Payment.create(company_id: company.id, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    customer = Customer.where(stripe_customer_id: event.data.object.customer).first
    company = customer.company
    company.deactivate!
  end
end


