class CreateSectionOptions < ActiveRecord::Migration
  def change
    create_table :section_options do |t|
      t.integer :scorecard_section_id
      t.string :body
    end
  end
end
