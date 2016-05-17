class AddCompanyIdToJobs < ActiveRecord::Migration
  def change
    add_column :job_postings, :company_id, :integer
    add_column :job_postings, :created_at, :datetime
    add_column :job_postings, :updated_at, :datetime
  end
end
