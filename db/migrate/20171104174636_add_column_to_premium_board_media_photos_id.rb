class AddColumnToPremiumBoardMediaPhotosId < ActiveRecord::Migration
  def change
    add_column :media_photos, :premium_board_id, :integer
  end
end
