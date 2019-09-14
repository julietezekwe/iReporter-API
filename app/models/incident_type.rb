class IncidentType < ApplicationRecord
  validates :title, presence: true

  has_many :incidents
end
