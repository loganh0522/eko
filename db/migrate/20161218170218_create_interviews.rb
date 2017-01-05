class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.string :notes
      t.integer :application_id
      t.string :kind
      t.datetime :date
      t.string :start_time
      t.string :end_time
      t.string :location
      t.string :status

      t.timestamps
    end
  end
end
