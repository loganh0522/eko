class CreateHeaderLinks < ActiveRecord::Migration
  def change
    create_table :header_links do |t|
      t.integer :job_board_row_id
      t.integer :job_board_id
      t.string :name
      t.timestamps
    end
  end
end
