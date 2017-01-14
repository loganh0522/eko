class ChangeInterviewsTableAddJobId < ActiveRecord::Migration
  def change
    add_column :interviews, :job_id, :integer
    add_column :interviews, :company_id, :integer
    change_column :interviews, :date, :string
  end
end
