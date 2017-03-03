class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.string :url 
      t.string :kind
      t.integer :user_id
    end
  end
end
