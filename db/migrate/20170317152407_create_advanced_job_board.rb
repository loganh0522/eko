class CreateAdvancedJobBoard < ActiveRecord::Migration
  def change
    add_column :job_boards, :cover_photo, :string
    add_column :job_boards, :header, :string
    add_column :job_boards, :subheader, :string
    add_column :job_boards, :brand_color, :string
    add_column :job_boards, :sub_heading_color, :string
    add_column :job_boards, :text_color, :string
    add_column :job_boards, :nav_color, :string
    add_column :job_boards, :font_family, :string
  end
end
