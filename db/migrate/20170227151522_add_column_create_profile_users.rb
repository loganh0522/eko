class AddColumnCreateProfileUsers < ActiveRecord::Migration
  def change
    add_column :users, :create_profile, :boolean
  end
end
