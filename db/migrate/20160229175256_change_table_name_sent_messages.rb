class ChangeTableNameSentMessages < ActiveRecord::Migration
  def change
    rename_table :sent_messages, :messages
    add_column :messages, :created_at, :datetime
    add_column :messages, :updated_at, :datetime
  end
end
