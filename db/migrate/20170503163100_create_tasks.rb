class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :taskable_id
      t.string :taskable_type
      t.integer :user_id
      t.string :title
      t.text :notes
      t.date :due_date
      t.integer :stage_id
      t.timestamps
    end
  end
end
