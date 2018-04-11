class AddColumnToPremiumZip < ActiveRecord::Migration
  def change
    add_column :ziprecruiter_premium_feeds, :boost, :boolean, default: false
    remove_column :ziprecruiter_premium_feeds, :zip_recruiter_boost
  end
end
