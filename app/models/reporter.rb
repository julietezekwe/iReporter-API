class Reporter < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 70 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }, length: { maximum: 75 }

  has_secure_password
  has_many :reported_incidents, class_name: "Incident", foreign_key: "reporter_id" 
  has_many :follows, class_name: "Follow", foreign_key: "follower_id"
  has_many :followed_incidents, through: :follows, source: :follower

  mount_uploader :avatar, AvatarUploader
end
