class RenameTableNameJobPostingsToJobs < ActiveRecord::Migration
  def change
    drop_table :jobs
    rename_table :job_postings, :jobs
  end
end
