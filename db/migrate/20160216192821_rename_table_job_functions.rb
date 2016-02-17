class RenameTableJobFunctions < ActiveRecord::Migration
  def change
    remove_column :job_functions, :work_experience_id
    remove_column :job_functions, :job_id
    rename_table :job_functions, :functions
    add_column :functions, :job_functions_id, :integer
  end
end
