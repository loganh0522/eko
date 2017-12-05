class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :link
      t.string :file
      t.string :title
      t.text :description
      t.timestamps 
    end
  end
end
