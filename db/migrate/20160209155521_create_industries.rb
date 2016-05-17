class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.text :name 
      t.integer :job_id, :work_experience_id
    end
  end
end
