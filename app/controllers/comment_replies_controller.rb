class CommentRepliesController < ApplicationController
  before_action :check_incident_comment, only: :create
  before_action :set_comment_reply, except: :create

  def create
    @comment_reply = CommentReply.create!(
      body: params[:body],
      reporter_id: current_user.id, 
      comment_id: params[:comment_id]
    )

    json_response({
      message: Message.report_success('Reply'),
      data: @comment_reply
    }, :created)
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 401) unless is_mine?(@comment_reply) || is_admin?

    @comment_reply.destroy
    json_response({ message: Message.delete_success('Reply') }, :ok)
  end

  private

  def check_incident_comment
    incident = Incident.find(params[:incident_id])
    incident.comments.find(params[:comment_id])
  end

  def set_comment_reply
    comment = check_incident_comment()
    @comment_reply = comment.comment_replies.find(params[:id])
  end
end
