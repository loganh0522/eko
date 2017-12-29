class AddColumnNeuvooPremiumToJobFeed < ActiveRecord::Migration
  def change
    add_column :order_items, :posting_duration_id, :integer
    add_column :order_items, :created_at, :datetime
    add_column :order_items, :updated_at, :datetime
    add_column :orders, :created_at, :datetime
    add_column :orders, :updated_at, :datetime
    add_column :job_feeds, :nuevoo_premium, :boolean
  end
end
