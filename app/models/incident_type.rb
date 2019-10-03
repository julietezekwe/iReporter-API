class IncidentType < ApplicationRecord
  after_save :index_incidents_in_elasticsearch

  validates :title, presence: true

  has_many :incidents

  private

  def index_incidents_in_elasticsearch
    incidents.find_each { |incident| incident.__elasticsearch__.index_document }
  end
end
