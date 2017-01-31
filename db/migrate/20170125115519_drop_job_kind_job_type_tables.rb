class DropJobKindJobTypeTables < ActiveRecord::Migration
  def change
    drop_table :job_types
    drop_table :job_kinds
    drop_table :job_states
    drop_table :job_experience_levels
    drop_table :job_education_levels
    drop_table :job_career_levels
  end
end
