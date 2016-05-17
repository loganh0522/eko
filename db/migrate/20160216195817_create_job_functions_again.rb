class CreateJobFunctionsAgain < ActiveRecord::Migration
  def change
    create_table :job_functions do |t|
      t.integer :job_id
    end
  end
end
