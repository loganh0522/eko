class CreateOverallRating < ActiveRecord::Migration
  def change
    create_table :overall_ratings do |t|
      t.integer :rating 
      t.integer :user_id
      t.integer :application_scorecard_id
    end
  end
end
