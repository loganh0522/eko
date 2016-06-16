class CreateUserAvatars < ActiveRecord::Migration
  def change
    create_table :user_avatars do |t|
      t.string :image 
      t.string :small_image
      t.string :medium_image
      t.string :large_image
      t.string :xs_image
      t.string :xl_image
      t.integer :user_id
      t.timestamps 
    end
  end
end
