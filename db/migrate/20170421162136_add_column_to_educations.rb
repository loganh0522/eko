class AddColumnToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :application_id, :integer
    add_column :educations, :applicant_id, :integer
  end
end
