class CreateAssignedUsers < ActiveRecord::Migration
  def change
    create_table :assigned_users do |t|
      t.integer :user_id
      t.integer :assignable_id
      t.integer :assignable_type
    end
  end
end
