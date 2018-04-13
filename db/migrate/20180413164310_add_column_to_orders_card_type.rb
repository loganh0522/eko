class AddColumnToOrdersCardType < ActiveRecord::Migration
  def change
    add_column :orders, :card_brand, :string
    add_column :orders, :card_exp_month, :string
    add_column :orders, :card_exp_year, :string
    add_column :orders, :charge_id, :string
    add_column :orders, :amount_refunded, :integer
    add_column :orders, :refunded, :boolean
    add_column :orders, :stripe_id, :string
    add_column :orders, :tax_amount, :integer
    add_column :orders, :tax_percentage, :decimal
    add_index :orders, :stripe_id, unique: true
  end
end
