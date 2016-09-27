class ChangeColumnOpenJobsInCompany < ActiveRecord::Migration
  def change
    change_column :companies, :open_jobs, :integer, :default => 0, :null => false
  end
end
