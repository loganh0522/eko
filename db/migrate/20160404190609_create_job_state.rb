class CreateJobState < ActiveRecord::Migration
  def change
    create_table :job_states do |t|
      t.integer :state_id
      t.integer :job_id
      t.integer :work_experience_id
    end
  end
end
