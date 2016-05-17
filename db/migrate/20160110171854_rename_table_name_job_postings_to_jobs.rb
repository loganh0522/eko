class RenameTableNameJobPostingsToJobs < ActiveRecord::Migration
  def change
    rename_table :job_postings, :jobs
  end
end
