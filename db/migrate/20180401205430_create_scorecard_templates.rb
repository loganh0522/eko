class CreateScorecardTemplates < ActiveRecord::Migration
  def change
    create_table :scorecard_templates do |t|
      t.integer :company_id
      t.string :name
      t.timestamps
    end
    add_column :section_options, :scorecard_templates_id, :integer
  end
end
