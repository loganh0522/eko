class AddColumnsToJobsForRecruiters < ActiveRecord::Migration
  def change
    add_column :jobs, :recruiter_description, :text
  end
end
