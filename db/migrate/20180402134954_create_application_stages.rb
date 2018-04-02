class CreateApplicationStages < ActiveRecord::Migration
  def change
    create_table :application_stages do |t|
      t.string :name
      t.integer :position
      t.integer :job_id
      t.integer :application_id
      t.datetime :added_on
      t.datetime :moved_from
      t.boolean :last_stage, default: false
      t.boolean :current_stage, default: false
      t.datetime 
      t.timestamps
    end

    add_column :stage_actions, :application_stage_id, :integer
  end
end
