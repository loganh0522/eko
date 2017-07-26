class AddColumnToCandidatesTable < ActiveRecord::Migration
  def change
    add_column :candidates, :full_name, :string
  end
end
