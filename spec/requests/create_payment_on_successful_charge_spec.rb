require 'spec_helper'

describe "create Payment on Successful charge" do 
  let(:event_data) do
    {
      "id" => "evt_18JiNYBDRuCwc6R2cAyZA6DY",
      "object" => "event",
      "api_version" => "2015-10-16",
      "created" => 1465298896,
      "data" => {
        "object" => {
          "id" => "ch_18JiNYBDRuCwc6R26vZQNz18",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_18JiNYBDRuCwc6R2UB2MNmjv",
          "captured" => true,
          "created" => 1465298896,
          "currency" => "cad",
          "customer" => "cus_8Z2JOTzC6WSeet",
          "description" => "Charge successful",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_18JiNYBDRuCwc6R26vZQNz18/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_18JiN1BDRuCwc6R2elyDunEF",
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
            "exp_month" => 6,
            "exp_year" => 2017,
            "fingerprint" => "SAow76ubNBhomPEk",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8auBEdKESjzn3e",
      "type" => "charge.succeeded"
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
    expect(Payment.first.reference_id).to eq("ch_18JiNYBDRuCwc6R26vZQNz18")
  end
end