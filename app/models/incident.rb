class Incident < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :evidence, presence: true
  validates :narration, presence: true, length: { maximum: 400 }
  validates :location, presence: true
  validates :status, presence: true, length: { maximum: 100 }
  validates :reporter_id, presence: true
  validates :incident_type_id, presence: true

  belongs_to :incident_type
  belongs_to :reporter
  has_many :follows, class_name: "Follow", foreign_key: "following_id"
  has_many :following_reporters, through: :follows, source: :following

  # uploader was disabled for testing in Postman
  # mount_uploader :evidence, EvidenceUploader
end
