class AddColumnToTaggings < ActiveRecord::Migration
  def change
    add_column :tags, :company_id, :integer
  end
end
