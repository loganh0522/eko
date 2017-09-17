class RenamePremiumJobBoard < ActiveRecord::Migration
  def change
    add_column :premium_boards, :kind, :string
    change_column :premium_boards, :price, :decimal
  end
end
