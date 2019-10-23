class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user

  def is_admin?
    current_user.is_admin
  end

  def is_mine?(obj)
    obj[:reporter_id] == current_user.id
  end

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
