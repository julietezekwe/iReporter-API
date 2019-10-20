class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :incident
  belongs_to :reporter
  has_many :comment_replies, dependent: :destroy
end
