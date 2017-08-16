class AddAndEditColumnToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :job_count, :integer, :default => 0, :null => false
    remove_column :companies, :open_jobs
    add_column :companies, :max_jobs, :integer, :default => 3, :null => false
  end
end
