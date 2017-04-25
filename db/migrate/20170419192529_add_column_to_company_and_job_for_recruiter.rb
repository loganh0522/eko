class AddColumnToCompanyAndJobForRecruiter < ActiveRecord::Migration
  def change
    add_column :jobs, :client_id, :integer
    add_column :companies, :kind, :string
  end
end
