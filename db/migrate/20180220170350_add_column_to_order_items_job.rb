class AddColumnToOrderItemsJob < ActiveRecord::Migration
  def change
    add_column :order_items, :job_id, :integer 
    add_column :premium_boards, :line_item_title, :string
    add_column :premium_boards, :email_to, :boolean, default: false
    add_column :premium_boards, :contact_email, :boolean
    add_column :orders, :title, :string
    add_column :orders, :description, :string
  end
end
