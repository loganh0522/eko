class RemoveColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :full_name
  end
end
