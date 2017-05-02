class AddThreadIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :thread_id, :string
  end
end
