class AddColumnApplicantIdToWorkExperience < ActiveRecord::Migration
  def change
    add_column :work_experiences, :applicant_id, :integer
  end
end
