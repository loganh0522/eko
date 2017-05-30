class CreateJobFeeds < ActiveRecord::Migration
  def change
    create_table :job_feeds do |t|
      t.integer :job_id
      t.boolean :adzuna
      t.boolean :jooble
      t.boolean :indeed
      t.boolean :trovit
      t.boolean :juju
      t.boolean :eluta
      t.boolean :monster
      t.boolean :glassdoor
      t.boolean :careerjet
      t.boolean :ziprecruiter
      t.boolean :neuvoo
      t.boolean :jobinventory
      t.boolean :recruitnet
      t.boolean :jobisjob
      t.boolean :jobrapido
      t.boolean :usjobs
    end
  end
end
