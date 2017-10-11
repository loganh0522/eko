class AddColumnLocationToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :location, :string
  end
end
