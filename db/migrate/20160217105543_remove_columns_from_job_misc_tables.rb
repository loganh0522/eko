class RemoveColumnsFromJobMiscTables < ActiveRecord::Migration
  def change
    remove_column :functions, :job_function_id
    remove_column :career_levels, :job_career_levels
    remove_column :education_levels, :job_education_levels
    remove_column :experience_levels, :job_id
    remove_column :industries, :job_industry_id
    remove_column :job_kinds, :job_type_id
  end
end
