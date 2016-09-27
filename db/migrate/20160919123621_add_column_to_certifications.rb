class AddColumnToCertifications < ActiveRecord::Migration
  def change
    add_column :certifications, :agency, :string
    add_column :certifications, :acronym, :string
  end
end
