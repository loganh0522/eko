class CreateJobPosting < ActiveRecord::Migration
  def change
    create_table :job_postings do |t|
      t.string :title, :country, :province, :city, :postal_code
      t.text :description, :benefits
      t.timestamps
    end
  end
end
