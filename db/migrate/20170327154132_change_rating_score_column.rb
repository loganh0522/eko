class ChangeRatingScoreColumn < ActiveRecord::Migration
  def change
    change_column :ratings, :score, :float
  end
end
