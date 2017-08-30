class AddIndexToCandidate < ActiveRecord::Migration
  def change
    add_index(:candidates, :company_id) unless index_exists?(:candidates, :company_id)
  end
end
