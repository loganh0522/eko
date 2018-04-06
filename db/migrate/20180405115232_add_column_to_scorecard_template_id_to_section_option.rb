class AddColumnToScorecardTemplateIdToSectionOption < ActiveRecord::Migration
  def change
    add_column :section_options, :scorecard_template_id, :integer
    remove_column :section_options, :scorecard_templates_id, :integer
  end
end
