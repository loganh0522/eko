class CreateSectionOptionsRating < ActiveRecord::Migration
  def change
    create_table :scorecard_ratings do |t|
      t.integer :section_option_id, :user_id, :application_id, :rating
    end
  end
end
