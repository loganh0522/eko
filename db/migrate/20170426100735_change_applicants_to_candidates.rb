class ChangeApplicantsToCandidates < ActiveRecord::Migration
  def change
    rename_table :applicants, :candidates
    add_column :work_experiences, :candidate_id, :integer
    add_column :educations, :candidate_id, :integer
    remove_column :work_experiences, :applicant_id
    remove_column :work_experiences, :application_id
    remove_column :educations, :application_id
    remove_column :educations, :applicant_id
  end
end
