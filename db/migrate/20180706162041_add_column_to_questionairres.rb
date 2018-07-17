class AddColumnToQuestionairres < ActiveRecord::Migration
  def change
  	add_column :questionairres, :candidate_id, :integer
  	add_column :questions, :questionairre_id, :integer
  end
end
