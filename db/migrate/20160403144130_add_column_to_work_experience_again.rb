class AddColumnToWorkExperienceAgain < ActiveRecord::Migration
  def change
    add_column :work_experiences, :country, :string
    add_column :work_experiences, :state, :string
    add_column :work_experiences, :city, :string
  end
end
