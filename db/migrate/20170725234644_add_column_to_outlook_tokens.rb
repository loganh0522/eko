class AddColumnToOutlookTokens < ActiveRecord::Migration
  def change
    add_column :outlook_tokens, :room_id, :integer
  end
end
