class AddRoomIdToEventId < ActiveRecord::Migration
  def change
    add_column :event_ids, :room_id, :integer
  end
end
