class AddColumnToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :address, :string
  end
end
