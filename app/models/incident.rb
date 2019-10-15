require 'elasticsearch/model'

class Incident < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :title, presence: true, length: { maximum: 100 }
  validates :evidence, presence: true
  validates :narration, presence: true, length: { maximum: 400 }
  validates :location, presence: true
  validates :status, inclusion: { in: %w(draft investigating resolved rejected) }
  validates :reporter_id, presence: true
  validates :incident_type_id, presence: true

  belongs_to :incident_type
  belongs_to :reporter
  has_many :follows, class_name: "Follow", foreign_key: "following_id"
  has_many :following_reporters, through: :follows, source: :following
  has_many :comments

  # uploader was disabled for testing in Postman
  # mount_uploader :evidence, EvidenceUploader

  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :location, :narration, :status],
      include: {
        reporter: { only: :name },
        incident_type: { only: :title }
      }
    )
  end

  index_name "incidents-#{Rails.env}"
end
