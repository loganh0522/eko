class AddColumnToZiprecruiterPremiumFeedExpired < ActiveRecord::Migration
  def change
   add_column :ziprecruiter_premium_feeds, :expired, :boolean, :default => false
  end
end
