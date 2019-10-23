class CommentsController < ApplicationController
  before_action :set_comment, except: [:create]

  def create
    @comment = Comment.create!(
      body: params[:body], 
      reporter_id: current_user.id, 
      incident_id: params[:incident_id]
    )

    json_response({
      message: Message.report_success('Comment'),
      data: @comment
    }, :created)
  end

  def update
    return json_response({ error: Message.unauthorized }, 401) unless is_mine?(@comment)
    @comment.update!(body: params[:body])
    
    json_response({
      message: Message.update_success('Comment'),
      data: @comment
    }, :ok)
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 401) unless is_mine?(@comment) || is_admin?

    @comment.destroy
    json_response({ message: Message.delete_success('Comment')}, :ok)
  end

  private

  def set_comment
    @incident = Incident.find(params[:incident_id])
    @comment = @incident.comments.find(params[:id])
  end
end
