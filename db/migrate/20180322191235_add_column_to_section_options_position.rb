class AddColumnToSectionOptionsPosition < ActiveRecord::Migration
  def change
    add_column :section_options, :position, :integer
  end
end
