class ChangeColumnNames < ActiveRecord::Migration
  def change
    rename_column :job_career_levels, :career_level_id, :job_id
    rename_column :job_education_levels, :education_level_id, :job_id
    rename_column :job_types, :job_kind_id, :job_id
  end
end
