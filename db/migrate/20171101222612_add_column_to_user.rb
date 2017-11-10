class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :profile_stage, :string
  end
end
