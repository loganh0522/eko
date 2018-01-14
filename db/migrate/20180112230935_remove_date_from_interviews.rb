class RemoveDateFromInterviews < ActiveRecord::Migration
  def change
    remove_column :interviews, :date
  end
end
