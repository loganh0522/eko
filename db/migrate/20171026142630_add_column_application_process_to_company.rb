class AddColumnApplicationProcessToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :application_process, :string
  end
end
