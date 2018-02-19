class ChangeColumnTitleToStringInInterviewKi < ActiveRecord::Migration
  def change
    remove_column :interview_kits, :title
    add_column :interview_kits, :title, :string
  end
end
