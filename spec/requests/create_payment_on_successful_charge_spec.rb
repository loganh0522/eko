require 'spec_helper'

describe "create Payment on Successful charge" do 
  let(:event_data) do
    {
      "id" => "evt_19GvegBDRuCwc6R23PIAyapS",
      "object" => "event",
      "api_version" => "2015-10-16",
      "created" => 1479411282,
      "data" => {
        "object" => {
          "id" => "ch_19GvefBDRuCwc6R2YRDduQa1",
          "object" => "charge",
          "amount" => 19000,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_19GvefBDRuCwc6R2g4yOPtRi",
          "captured" => true,
          "created" => 1479411281,
          "currency" => "cad",
          "customer" => "cus_9a5pSbMcu4a5q1",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => "in_19GvefBDRuCwc6R22Ti3YPpr",
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_19GvefBDRuCwc6R2YRDduQa1/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_19GvduBDRuCwc6R2QIZpUutW",
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
            "customer" => "cus_9a5pSbMcu4a5q1",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2016,
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
      "request" => "req_9a5qbprNOhmtDA",
      "type" => "charge.succeeded"
    }
  end

  it "creates a payment with webhook from stripe with charge succeeded", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a5pSbMcu4a5q1')
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with the company", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a5pSbMcu4a5q1')
    post '/stripe_events', event_data
    expect(Payment.first.company).to eq(talentwiz)
  end

  it "creates the payment with the amount", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a5pSbMcu4a5q1')
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(19000)
  end

  it "creates the reference_id for the payment", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a5pSbMcu4a5q1')
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_19GvefBDRuCwc6R2YRDduQa1")
  end
end