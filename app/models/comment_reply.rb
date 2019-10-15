class CommentReply < ApplicationRecord
  validates :body, presence: true

  belongs_to :reporter
  belongs_to :comment
end
