class CreateJobBoards < ActiveRecord::Migration
  def change
    create_table :job_boards do |t|
      t.string :subdomain, :logo
      t.integer :company_id
      t.text :description
    end
  end
end
