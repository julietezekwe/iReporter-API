class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :incident_id, :created_at, :updated_at, :comment_replies
  
  has_one :reporter

  def comment_replies
    comment_replies = []

    object.comment_replies.each do |comment_reply|
      comment_reply_hash =  comment_reply.attributes
      comment_reply_hash[:comment_reply_reporter] = comment_reply.reporter
      comment_replies << comment_reply_hash
    end
    comment_replies
  end
end
