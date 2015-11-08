class RenameJobPostingsTable < ActiveRecord::Migration
  def change
    rename_table :job_postings, :job_posting
  end
end
