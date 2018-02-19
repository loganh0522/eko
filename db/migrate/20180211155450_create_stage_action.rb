class CreateStageAction < ActiveRecord::Migration
  def change
    create_table :stage_actions do |t|
      t.integer :stage_id
      t.integer :assigned_to
      t.integer :interview_kit_id
      t.text :message
      t.string :subject
      t.boolean :automate
      t.string :name
      t.string :kind
      t.timestamps
    end
  end
end
