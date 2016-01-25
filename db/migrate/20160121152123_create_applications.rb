class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :job_id
      t.integer :user_id
      t.integer :stage_id
    end
  end
end

