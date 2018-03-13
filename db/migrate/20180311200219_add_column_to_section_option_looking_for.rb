class AddColumnToSectionOptionLookingFor < ActiveRecord::Migration
  def change
    add_column :section_options, :quality_answer, :text
  end
end
