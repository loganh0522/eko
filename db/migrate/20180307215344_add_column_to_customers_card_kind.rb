class AddColumnToCustomersCardKind < ActiveRecord::Migration
  def change
    add_column :customers, :card_brand, :string
    add_column :orders, :last_four, :string
    add_column :orders, :invoice_date, :datetime
  end
end
