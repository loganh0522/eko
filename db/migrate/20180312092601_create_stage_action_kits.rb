class CreateStageActionKits < ActiveRecord::Migration
  def change
    create_table :stage_action_kits do |t|
      t.integer :stage_action_id
      t.integer :interview_kit_template_id
      t.timestamps
    end
    
    add_column :interview_kits, :created_at, :datetime, null: false
    add_column :interview_kits, :updated_at, :datetime, null: false
  end
end
