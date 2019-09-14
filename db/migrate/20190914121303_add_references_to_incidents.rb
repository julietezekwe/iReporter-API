class AddReferencesToIncidents < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :incidents, :users, column: :reporter_id, on_delete: :cascade
    add_foreign_key :incidents, :incident_types, column: :incident_type_id
    add_foreign_key :follows, :users, column: :follower_id, on_delete: :cascade
    add_foreign_key :follows, :incidents, column: :following_id, on_delete: :cascade
  end
end
