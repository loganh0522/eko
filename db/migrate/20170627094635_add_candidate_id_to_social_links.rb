class AddCandidateIdToSocialLinks < ActiveRecord::Migration
  def change
    add_column :social_links, :candidate_id, :integer
  end
end
