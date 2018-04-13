require "stripe"

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

class RecordCharges
  def call(event)
    charge = event.data.object
    
    if charge.invoice.present? 
      invoice = Stripe::Invoice.retrieve(charge.invoice) 
      plan_name = invoice.lines.data.first.plan.name

      customer = Customer.find_by(stripe_customer_id: charge.customer)
      company = customer.company
    
      c = company.orders.where(stripe_id: charge.id).first_or_create

      c.update(
        total: charge.amount,
        title: plan_name,
        tax_amount: invoice.tax,
        tax_percentage: invoice.tax_percent,
        subtotal: invoice.subtotal,
        last_four: charge.source.last4, 
        card_brand: charge.source.brand,
        card_exp_month: charge.source.exp_month, 
        card_exp_year: charge.source.exp_year
      )
    end
  end
end


StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded', RecordCharges.new

  events.subscribe 'charge.failed' do |event|
    customer = Customer.where(stripe_customer_id: event.data.object.customer).first
    company = customer.company
    customer.update_attribute(:stripe_subscription_id, nil)
    customer.update_attribute(:plan, nil)
    company.deactivate!
  end
end


