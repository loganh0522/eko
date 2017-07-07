class CreateInterviewTimes < ActiveRecord::Migration
  def change
    create_table :interview_times do |t|
      t.date :date
      t.time :time
      t.integer :interview_invitation
    end
  end
end
