class AddEmailColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :email_id, :string
  end
end
