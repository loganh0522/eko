class RenameColumnFunctionsJobFunctionsId < ActiveRecord::Migration
  def change
    remove_column :functions, :job_functions_id
    add_column :functions, :job_function_id, :integer
  end
end
