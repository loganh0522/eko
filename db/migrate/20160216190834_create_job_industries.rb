class CreateJobIndustries < ActiveRecord::Migration
  def change
    create_table :job_industries do |t|
      t.integer :job_id
    end
  end
end
