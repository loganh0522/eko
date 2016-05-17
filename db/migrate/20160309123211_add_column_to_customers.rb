class AddColumnToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :stripe_subscription_id, :string
    add_column :customers, :full_name, :string 
    add_column :customers, :postal_code, :string
    add_column :customers, :exp_month, :integer
    add_column :customers, :exp_year, :integer
  end
end
