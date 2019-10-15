class Reporter < ApplicationRecord
  after_save :index_incidents_in_elasticsearch
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password

  validates :name, presence: true, length: { maximum: 70 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }, length: { maximum: 75 }
  validates :password_digest, presence: true

  has_many :reported_incidents, class_name: "Incident", foreign_key: "reporter_id" 
  has_many :follows, class_name: "Follow", foreign_key: "follower_id"
  has_many :followed_incidents, through: :follows, source: :follower
  has_many :comments

  mount_uploader :avatar, AvatarUploader

  private

  def index_incidents_in_elasticsearch
    reported_incidents.find_each { |incident| incident.__elasticsearch__.index_document }
  end
end
