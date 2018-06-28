class AddColumnPolyNotifiable < ActiveRecord::Migration
  def change
  	remove_column :notifications, :notifiable_id
  	remove_column :notifications, :notifiable_type
  	add_column :notifications, :notifiable_id, :integer, polymorphic: true
  	add_column :notifications, :notifiable_type, :string, polymorphic: true
  end
end
