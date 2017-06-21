class ChangeColumnInterviewsDate < ActiveRecord::Migration
  def change
    remove_column :interviews, :interview_date
    add_column :interviews, :date, :string
  end
end
