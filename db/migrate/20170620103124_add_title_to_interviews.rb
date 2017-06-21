class AddTitleToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :title, :string
  end
end
