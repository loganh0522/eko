class CreateInterviewKitTemplates < ActiveRecord::Migration
  def change
    create_table :interview_kit_templates do |t|
      t.string :title
      t.integer :company_id
      t.text :body
      t.text :preperation
      t.timestamps
    end
  end
end
