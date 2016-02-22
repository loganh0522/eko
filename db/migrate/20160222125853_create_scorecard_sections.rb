class CreateScorecardSections < ActiveRecord::Migration
  def change
    create_table :scorecard_sections do |t|
      t.integer :scorecard_id
      t.string :body
    end
  end
end
