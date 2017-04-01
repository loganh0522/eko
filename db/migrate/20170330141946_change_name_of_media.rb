class ChangeNameOfMedia < ActiveRecord::Migration
  def change
     rename_table :media, :media_photos
  end
end
