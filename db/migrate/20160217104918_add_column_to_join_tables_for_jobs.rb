class AddColumnToJoinTablesForJobs < ActiveRecord::Migration
  def change
    add_column :job_career_levels, :career_level_id, :integer
    add_column :job_education_levels, :education_level_id, :integer
    add_column :job_functions, :function_id, :integer
    add_column :job_industries, :industry_id, :integer
    add_column :job_types, :job_kind_id, :integer
  end
end
