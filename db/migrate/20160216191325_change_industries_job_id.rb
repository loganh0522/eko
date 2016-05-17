class ChangeIndustriesJobId < ActiveRecord::Migration
  def change
    add_column :industries, :job_industry_id, :integer
    remove_column :industries, :job_id
  end
end
