class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.integer :user_id 
      t.text :body 
      t.string :title
      t.integer :estimated_time
      t.boolean :published, default: false
      t.datetime :published_at
      t.timestamps
    end
  end
end
