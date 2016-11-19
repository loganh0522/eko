require 'spec_helper'

describe "deactivate user on payment fail" do 
  let(:event_data) do
    {
      "id" => "evt_18JU4bBDRuCwc6R2sX7gXrVJ",
      "object" => "event",
      "api_version" => "2015-10-16",
      "created" => 1465243905,
      "data" => {
        "object" => {
          "id" => "ch_18JU4aBDRuCwc6R2x7XF3W7n",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1465243904,
          "currency" => "cad",
          "customer" => "cus_8Z2JOTzC6WSeet",
          "description" => "payment to fail",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_18JU4aBDRuCwc6R2x7XF3W7n/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_18JU0mBDRuCwc6R2AFU9DtuW",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_8Z2JOTzC6WSeet",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 8,
            "exp_year" => 2017,
            "fingerprint" => "DdC4tjdtETYQoYql",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8afPaZ7QuSPDai",
      "type" => "charge.failed"
    }
  end

  it "creates a payment with webhook from stripe with charge succeeded", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_8Z2JOTzC6WSeet')
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with the company", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_8Z2JOTzC6WSeet')
    post '/stripe_events', event_data
    expect(Payment.first.company).to eq(talentwiz)
  end

  it "creates the payment with the amount", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_8Z2JOTzC6WSeet')
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the reference_id for the payment", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_8Z2JOTzC6WSeet')
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_19GvefBDRuCwc6R2YRDduQa1")
  end
end