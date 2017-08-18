class AddColumnConversationIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :conversation_id, :integer
    remove_column :messages, :application_id
  end
end
