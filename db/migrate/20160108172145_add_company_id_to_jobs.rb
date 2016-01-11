class AddCompanyIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :company_id, :integer
    add_column :jobs, :created_at, :datetime
    add_column :jobs, :updated_at, :datetime
  end
end
