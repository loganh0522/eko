class CreateDefaultStages < ActiveRecord::Migration
  def change
    create_table :default_stages do |t|
      t.string :name
      t.integer :position
      t.integer :company_id
      t.timestamps
    end
  end
end
