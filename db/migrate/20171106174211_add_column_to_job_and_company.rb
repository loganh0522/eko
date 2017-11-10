class AddColumnToJobAndCompany < ActiveRecord::Migration
  def change
    add_column :jobs, :verified, :boolean, :default => false
    add_column :companies, :verified, :boolean, :default => false
    add_column :job_feeds, :created_at, :datetime
    add_column :job_feeds, :updated_at, :datetime
    add_column :job_feeds, :juju_updated_at, :datetime
  end
end
