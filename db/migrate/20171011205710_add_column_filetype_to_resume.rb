class AddColumnFiletypeToResume < ActiveRecord::Migration
  def change
    add_column :resumes, :filetype, :string
  end
end
