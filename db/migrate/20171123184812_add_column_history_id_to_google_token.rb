class AddColumnHistoryIdToGoogleToken < ActiveRecord::Migration
  def change
    add_column :google_tokens, :history_id, :string
  end
end
