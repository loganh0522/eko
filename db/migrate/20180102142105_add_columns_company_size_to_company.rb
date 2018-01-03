class AddColumnsCompanySizeToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :location, :string
    add_column :companies, :country, :string
    add_column :companies, :city, :string
    add_column :companies, :province, :string
    add_column :companies, :size, :integer
  end
end
