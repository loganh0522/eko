class AddColumnToProfile < ActiveRecord::Migration
  def change
    remove_column :users, :create_profile
  end
end
