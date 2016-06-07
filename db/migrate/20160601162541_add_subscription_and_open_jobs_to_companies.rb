class AddSubscriptionAndOpenJobsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :open_jobs, :integer
    add_column :companies, :subscription, :string
  end
end
