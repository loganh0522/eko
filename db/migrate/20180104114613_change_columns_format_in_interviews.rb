class ChangeColumnsFormatInInterviews < ActiveRecord::Migration
  def change
    remove_column :interviews, :start_time
    remove_column :interviews, :end_time
    add_column :interviews, :start_time, :datetime
    add_column :interviews, :end_time, :datetime
    add_column :interview_times, :start_time, :datetime
    add_column :interview_times, :end_time, :datetime
  end
end
