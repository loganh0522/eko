class AddColumnToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :duration, :string
  end
end
