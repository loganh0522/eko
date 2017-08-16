class AddSubscriptionIdToOutlookToken < ActiveRecord::Migration
  def change
    add_column :outlook_tokens, :subscription_id, :string
    add_column :outlook_tokens, :subscription_expiration, :datetime
  end
end
