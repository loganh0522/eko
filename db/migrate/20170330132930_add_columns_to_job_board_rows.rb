class AddColumnsToJobBoardRows < ActiveRecord::Migration
  def change
    add_column :job_board_rows, :kind, :string
    add_column :job_board_rows, :layout, :string

  end
end
