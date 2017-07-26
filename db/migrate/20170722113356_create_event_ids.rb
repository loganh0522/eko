class CreateEventIds < ActiveRecord::Migration
  def change
    create_table :event_ids do |t|
      t.integer :interview_time_id
      t.string :event_id
      t.integer :user_id
    end
  end
end
