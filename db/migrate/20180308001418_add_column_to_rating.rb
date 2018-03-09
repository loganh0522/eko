class AddColumnToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :candidate_id, :integer
  end
end
