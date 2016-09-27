class CreateActivity < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :action
      t.string :trackable_type
      t.integer :trackable_id
      t.integer :user_id

      t.timestamps
    end
  end
end
