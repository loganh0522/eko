class AddColumnToJobFeedsZiprecruiterBoost < ActiveRecord::Migration
  def change
    add_column :job_feeds, :ziprecruiter_boost, :string
    add_column :job_feeds, :indeed_boost, :string
  end
end
