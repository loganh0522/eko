class AddColumnToSubsidiariesSubId < ActiveRecord::Migration
  def change
    add_column :subsidiaries, :subsidiary_id, :integer
  end
end
