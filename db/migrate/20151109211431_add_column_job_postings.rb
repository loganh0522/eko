class AddColumnJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :company_id, :integer 
  end
end
