class CommentRepliesController < ApplicationController
  before_action :check_incident_comment, except: :index

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

  private

  def check_incident_comment
    @incident = Incident.find(params[:incident_id])
    @comment = @incident.comments.find(params[:comment_id])
  end
end
