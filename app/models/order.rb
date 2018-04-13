class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :job
  
  has_many :order_items

  accepts_nested_attributes_for :order_items, 
    allow_destroy: true


  def receipt
    Receipts::Receipt.new(
      id: id,
      product: self.title,
      company: {
        name: "Talentwiz Solutions Inc.",
        address: "58 Haddington Ave, \nToronto, On m5m 2p1",
        email: "houston@talentwiz.ca",
        logo: Rails.root.join("/tmp/logo.jpg") 
      },
      line_items: [
        ["Date",           created_at.to_s],
        ["Account Billed", "#{user.name} (#{user.email})"],
        ["Product",        "GoRails"],
        ["Amount",         "$#{amount / 100}.00"],
        ["Charged to",     "#{card_type} (**** **** **** #{card_last4})"],
        ["Transaction ID", uuid]
      ],
      font: {
        bold: Rails.root.join('app/assets/fonts/tradegothic/TradeGothic-Bold.ttf'),
        normal: Rails.root.join('app/assets/fonts/tradegothic/TradeGothic.ttf'),
      }
    )
  end
end
end