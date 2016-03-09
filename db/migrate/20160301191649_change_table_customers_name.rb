class ChangeTableCustomersName < ActiveRecord::Migration
  def change
    remove_column :customers, :stripe_id
    add_column  :customers, :stripe_customer_id, :string
    add_column  :customers, :last_four, :string
  end
end
