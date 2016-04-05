class CreateExpIndustry < ActiveRecord::Migration
  def change
    create_table :exp_industries do |t|
      t.integer :industry_id
      t.integer :work_experience_id
    end
  end
end
