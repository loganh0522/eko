class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :cart_id
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :total_price
      t.decimal :unit_price
    end
  end
end
