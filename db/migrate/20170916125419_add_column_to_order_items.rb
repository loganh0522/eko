class AddColumnToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :premium_board_id, :integer
  end
end
