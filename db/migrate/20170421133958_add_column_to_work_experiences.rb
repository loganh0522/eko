class AddColumnToWorkExperiences < ActiveRecord::Migration
  def change
    add_column :work_experiences, :application_id, :integer
    add_column :applications, :manually_created, :boolean
    add_column :applications, :source, :string
  end
end
