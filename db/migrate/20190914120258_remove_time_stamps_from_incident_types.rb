class RemoveTimeStampsFromIncidentTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :incident_types, :created_at, :datetime
    remove_column :incident_types, :updated_at, :datetime
  end
end
