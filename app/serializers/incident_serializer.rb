class IncidentSerializer < ActiveModel::Serializer
  attributes :id, :title, :evidence, :narration, :location, :status, :incident_type_id, :created_at, :updated_at, :following_count

  has_one :reporter

  def following_count
    object.following_reporters.count
  end
end
