class CreateIncidents < ActiveRecord::Migration[5.2]
  def change
    create_table :incidents do |t|
      t.text :title
      t.text :evidence
      t.text :narration
      t.text :location
      t.string :status
      t.integer :reporter_id
      t.integer :incident_type_id

      t.timestamps
    end
  end
end
