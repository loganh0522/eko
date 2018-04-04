class CreateCompanyProfile < ActiveRecord::Migration
  def change
    create_table :company_profiles do |t|
      t.text :description
      t.integer :company_id
       

      t.timestamps
    end
  end

  add_column :background_images, :company_profile_id, :integer
  add_column :job_board_rows, :company_profile_id, :integer
end
