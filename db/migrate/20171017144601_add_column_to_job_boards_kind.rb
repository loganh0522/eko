class AddColumnToJobBoardsKind < ActiveRecord::Migration
  def change
    add_column :job_boards, :kind, :string
    add_column :job_boards, :app_process, :string
  end
end
