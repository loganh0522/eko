class AddColumnToJobFeedIndeedBudge < ActiveRecord::Migration
  def change
    add_column :job_feeds, :indeed_budget, :integer
    add_column :job_feeds, :career_builder, :boolean
    add_column :job_feeds, :dice, :boolean
    add_column :job_feeds, :stackoverflow, :boolean
  end
end
