class ChangeInterviewsTableChangeDateColumn < ActiveRecord::Migration
  def change
    add_column :interviews, :interview_date, :date
    remove_column :interviews, :date
  end
end
