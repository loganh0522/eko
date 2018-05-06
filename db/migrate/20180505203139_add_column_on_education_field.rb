class AddColumnOnEducationField < ActiveRecord::Migration
  def change
    add_column :educations, :field, :string
    add_column :educations, :location, :string
    add_column :certifications, :description, :text
    add_column :certifications, :start_month, :string
    add_column :certifications, :start_year, :string
    add_column :certifications, :end_month, :string
    add_column :certifications, :end_year, :string
    add_column :certifications, :candidate_id, :integer

    create_table :awards do |t|
      t.integer :candidate_id
      t.integer :user_id
      t.string :title
      t.string :date_month
      t.string :date_year
      t.text :description

      t.timestamps
    end

    create_table :candidate_associations do |t|
      t.integer :candidate_id
      t.integer :user_id
      t.string :title
      t.string :start_month
      t.string :start_year
      t.string :end_month
      t.string :end_year
      t.boolean :current
      t.text :description
      t.timestamps
    end

    create_table :publications do |t|
      t.integer :candidate_id
      t.integer :user_id
      t.string :title
      t.string :url
      t.datetime :date_published
      t.text :description

      t.timestamps
    end

    create_table :patents do |t|
      t.integer :candidate_id
      t.integer :user_id
      t.string :title
      t.string :url
      t.string :patent_number
      t.string :date_month
      t.string :date_year
      t.text :description

      t.timestamps
    end

    create_table :military_services do |t|
      t.integer :candidate_id
      t.integer :user_id
      t.string :rank
      t.string :branch
      t.string :service_country
      t.string :start_month
      t.string :start_year
      t.string :end_month
      t.string :end_year
      t.boolean :current
      t.string :commendations
      t.text :description
      
      t.timestamps
    end
  end
end
