class CreateBackgroundImages < ActiveRecord::Migration
  def change
    create_table :background_images do |t|
      t.integer :company_id
      t.integer :job_board_header_id
      t.integer :job_board_row_id
      t.integer :user_id
      t.string :file 
      t.timestamps
    end
  end
end
