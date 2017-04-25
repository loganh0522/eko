class MakeMessagesModelPolymorphic < ActiveRecord::Migration
  def change
    add_column :messages, :recipient_type, :string
    add_column :messages, :recipient_id, :integer
    add_column :comments, :commentable_type, :string
    add_column :comments, :commentable_id, :integer
  end
end
