class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :name
      t.integer :position
      t.integer :job_id
      t.timestamps
    end
  end
end
