class AddColumnToUserCertifications < ActiveRecord::Migration
  def change
    add_column :user_certifications, :description, :string
    add_column :user_certifications, :agency, :string
    add_column :user_certifications, :start_month, :string
    add_column :user_certifications, :start_year, :string
    add_column :user_certifications, :end_month, :string
    add_column :user_certifications, :end_year, :string
    add_column :user_certifications, :expires, :integer
  end
end
