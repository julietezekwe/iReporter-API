class CommentsController < ApplicationController
  def create
    @comment = Comment.create!(body: params[:body], reporter_id: current_user.id, incident_id: params[:incident_id])
    json_response({
      message: Message.comment_success,
      data: @comment
    }, :created)
  end
end
