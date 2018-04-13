class AddColumnToOrderDecimalTaxAmount < ActiveRecord::Migration
  def change
    change_column :orders, :tax_amount, :decimal
  end
end
