class CreateMyInterviews < ActiveRecord::Migration
  def change
    create_table :my_interviews do |t|
      t.integer :user_id
      t.integer :interview_id

      t.timestamps
    end
  end
end
