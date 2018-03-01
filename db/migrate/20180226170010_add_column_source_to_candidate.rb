class AddColumnSourceToCandidate < ActiveRecord::Migration
  def change
    add_column :question_answers, :file, :string
    remove_column :questions, :required
    add_column :questions, :required, :boolean, default: false 
  end
end

