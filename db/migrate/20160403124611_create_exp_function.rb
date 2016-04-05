class CreateExpFunction < ActiveRecord::Migration
  def change
    create_table :exp_functions do |t|
      t.integer :function_id
      t.integer :work_experience_id
    end
  end
end
