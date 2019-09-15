class Follow < ApplicationRecord
  validates :follower_id, presence: true
  validates :following_id, presence: true

  belongs_to :follower, class_name: "Reporter", foreign_key: "follower_id"
  belongs_to :following, class_name: "Incident", foreign_key: "following_id"
end
