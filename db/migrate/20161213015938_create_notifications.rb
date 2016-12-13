class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :action
      t.string :trackable_type
      t.integer :trackable_id
      t.integer :user_id
      t.integer :company_id
      t.integer :application_id
      t.integer :job_id

      t.timestamps
    end
  end
end
