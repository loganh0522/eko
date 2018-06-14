class ChangeNotificationsTable < ActiveRecord::Migration
  def change
  	remove_column :notifications, :trackable_type
  	remove_column :notifications, :trackable_id
  	add_column :notifications, :actor_id, :integer
  	add_column :notifications, :recipient_id, :integer
  	add_column :notifications, :read_at, :datetime
  	add_column :notifications, :notifiable_id, :integer
  	add_column :notifications, :notifiable_type, :integer
  end
end
