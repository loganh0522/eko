class AddColumnsToInterview < ActiveRecord::Migration
  def change
    add_column :interviews, :event_id, :string
  end
end
