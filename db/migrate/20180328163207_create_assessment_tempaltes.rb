class CreateAssessmentTempaltes < ActiveRecord::Migration
  def change
    create_table :assessment_templates do |t|
      t.integer :company_id
      t.string :name
      t.timestamps 
    end
    
    add_column :questions, :assessment_template_id, :integer
  end
end
