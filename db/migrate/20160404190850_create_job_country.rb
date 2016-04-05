class CreateJobCountry < ActiveRecord::Migration
  def change
    create_table :job_countries do |t|
      t.integer :country_id
      t.integer :job_id
      t.integer :work_experience_id
    end
  end
end
