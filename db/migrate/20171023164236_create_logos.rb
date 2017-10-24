class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.string :file 
      t.integer :company_id
      t.timestamps
    end
  end
end
