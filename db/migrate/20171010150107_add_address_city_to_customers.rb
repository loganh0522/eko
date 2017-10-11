class AddAddressCityToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :address, :string
    add_column :customers, :city, :string
    add_column :customers, :country, :string
    add_column :customers, :state, :string
  end
end
