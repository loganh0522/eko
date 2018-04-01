class AddColumnToCompanyCompanyNumber < ActiveRecord::Migration
  def change
    add_column :companies, :company_number, :string
  end
end
