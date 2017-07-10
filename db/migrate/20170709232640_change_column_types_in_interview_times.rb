class ChangeColumnTypesInInterviewTimes < ActiveRecord::Migration
  def change
    change_column :interview_times, :date, :string
    change_column :interview_times, :time, :string
  end
end
