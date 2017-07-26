class AddColumnToEventIds < ActiveRecord::Migration
  def change
    add_column :event_ids, :interview_id, :integer
  end
end
