class CommentsController < ApplicationController
  before_action :set_comment, except: [:create]

  def create
    @comment = Comment.create!(body: params[:body], reporter_id: current_user.id, incident_id: params[:incident_id])
    json_response({
      message: Message.comment_success,
      data: @comment
    }, :created)
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 401) unless my_comment?(@comment) || is_admin?
    @comment.destroy
    json_response({ message: Message.delete_success("Comment")}, :ok)
  end

  private

  def set_comment
    incident = Incident.find(params[:incident_id])
    @comment = incident.comments.find(params[:id])
  end

  def my_comment?(comment)
    comment[:reporter_id] == current_user.id
  end
end
