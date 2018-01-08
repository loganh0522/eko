class AddColumnToInterviewStringTime < ActiveRecord::Migration
  def change
    add_column :interviews, :stime, :string
    add_column :interviews, :etime, :string
  end
end
