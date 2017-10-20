class CreateRescheduleEvent < ActiveRecord::Migration
  def change
    create_table :reschedule_events do |t|
      t.integer :user_id
      t.text :body
      t.integer :candidate_id
      t.integer :interview_invitation_id
      t.integer :company_id
      t.integer :job_id
      t.timestamps
    end

    add_column :interview_times, :reschedule_event_id, :integer
  end
end
