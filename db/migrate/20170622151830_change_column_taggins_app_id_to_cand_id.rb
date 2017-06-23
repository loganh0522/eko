class ChangeColumnTagginsAppIdToCandId < ActiveRecord::Migration
  def change
    add_column :taggings, :candidate_id, :integer
    remove_column :taggings, :application_id
  end
end
