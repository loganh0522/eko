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
        logo: Rails.root.join("app/assets/images/logo_invoice.png") 
      },
      line_items: line_items
    )
  end

  def line_items
    
    items3 = [
        ["Subtotal",        "$#{subtotal / 100}"],
        ["Tax",            "$#{tax_amount / 100}"],
        ["Total",          "$#{total / 100}"],
        ["Charged to",     "#{card_brand} (**** **** **** #{last_four})"]
        ]

    items2 = []

    if self.order_items.count > 1 
      self.order_items.each do |item|
        items2 << [item.premium_board.name, "$#{item.unit_price.to_i}.00"]
      end   
    else
      self.order_items.each do |item|
        items2 << [item.premium_board.name, "$#{item.unit_price.to_i}.00"]
      end   
    end

    items = [
        ["Date",           created_at.to_s],
        ["Account Billed", company.name],
        ["Product",        self.title]] + items2 + items3

    items 

  end


end