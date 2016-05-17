class CreateJobTypes < ActiveRecord::Migration
  def change
    create_table :job_types do |t|
      t.integer :job_kind_id
    end
  end
end
