require 'spec_helper'

describe "invoice payment succeeds" do 
  let(:event_data) do
    {
      "id" => "evt_19HEVpBDRuCwc6R2CDYdRBc2",
      "object" => "event",
      "api_version" => "2015-10-16",
      "created" => 1479483769,
      "data" => {
        "object" => {
          "id" => "in_19HEVoBDRuCwc6R29HjBD1oP",
          "object" => "invoice",
          "amount_due" => 60911,
          "application_fee" => nil,
          "attempt_count" => 1,
          "attempted" => true,
          "charge" => "ch_19HEVoBDRuCwc6R2q9ca6SpB",
          "closed" => true,
          "currency" => "cad",
          "customer" => "cus_9a7sPGClqfgEoK",
          "date" => 1479483768,
          "description" => nil,
          "discount" => nil,
          "ending_balance" => 0,
          "forgiven" => false,
          "lines" => {
            "object" => "list",
            "data" => [
              {
                "id" => "ii_19HEVnBDRuCwc6R2WqMzKRGx",
                "object" => "line_item",
                "amount" => -39000,
                "currency" => "cad",
                "description" => "Unused time on Basic Year after 18 Nov 2016",
                "discountable" => false,
                "livemode" => false,
                "metadata" => {},
                "period" => {
                  "start" => 1479483770,
                  "end" => 1511019750
                },
                "plan" => {
                  "id" => "basic_year",
                  "object" => "plan",
                  "amount" => 39000,
                  "created" => 1464805185,
                  "currency" => "cad",
                  "interval" => "year",
                  "interval_count" => 1,
                  "livemode" => false,
                  "metadata" => {},
                  "name" => "Basic Year",
                  "statement_descriptor" => nil,
                  "trial_period_days" => nil
                },
                "proration" => true,
                "quantity" => 1,
                "subscription" => "sub_9aN9nIUXmY2sFg",
                "type" => "invoiceitem"
              },
              {
                "id" => "ii_19HEVnBDRuCwc6R20kx3p6ea",
                "object" => "line_item",
                "amount" => 99900,
                "currency" => "cad",
                "description" => "Remaining time on Team Year after 18 Nov 2016",
                "discountable" => false,
                "livemode" => false,
                "metadata" => {},
                "period" => {
                  "start" => 1479483770,
                  "end" => 1511019750
                },
                "plan" => {
                  "id" => "team_year",
                  "object" => "plan",
                  "amount" => 99900,
                  "created" => 1464805276,
                  "currency" => "cad",
                  "interval" => "year",
                  "interval_count" => 1,
                  "livemode" => false,
                  "metadata" => {},
                  "name" => "Team Year",
                  "statement_descriptor" => nil,
                  "trial_period_days" => nil
                },
                "proration" => true,
                "quantity" => 1,
                "subscription" => "sub_9aN9nIUXmY2sFg",
                "type" => "invoiceitem"
              }
            ],
            "has_more" => false,
            "total_count" => 2,
            "url" => "/v1/invoices/in_19HEVoBDRuCwc6R29HjBD1oP/lines"
          },
          "livemode" => false,
          "metadata" => {
            "action" => "update_plan"
          },
          "next_payment_attempt" => nil,
          "paid" => true,
          "period_end" => 1479483768,
          "period_start" => 1479483750,
          "receipt_number" => nil,
          "starting_balance" => 11,
          "statement_descriptor" => nil,
          "subscription" => nil,
          "subtotal" => 60900,
          "tax" => nil,
          "tax_percent" => nil,
          "total" => 60900,
          "webhooks_delivered_at" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_9aPKAJTyxIhgmU",
      "type" => "invoice.payment_succeeded"
    }
  end

  it "creates a payment with webhook from stripe with charge succeeded", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a7sPGClqfgEoK')
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with the company", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a7sPGClqfgEoK')
    post '/stripe_events', event_data
    expect(Payment.first.company).to eq(talentwiz)
  end

  it "creates the payment with the amount", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a7sPGClqfgEoK')
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(60911)
  end

  it "creates the reference_id for the payment", :vcr do 
    talentwiz = Fabricate(:company)
    customer = Fabricate(:customer, company: talentwiz, stripe_customer_id: 'cus_9a7sPGClqfgEoK')
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("in_19HEVoBDRuCwc6R29HjBD1oP")
  end
end