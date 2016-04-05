class AddColumnToWorkExperience < ActiveRecord::Migration
  def change
    remove_column :work_experiences, :end_date
    remove_column :work_experiences, :start_date
    add_column :work_experiences, :start_month, :string
    add_column :work_experiences, :start_year, :string
    add_column :work_experiences, :end_month, :string
    add_column :work_experiences, :end_year, :string
  end
end
