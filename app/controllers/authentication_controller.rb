class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token = AuthenticateUser.new(nil, auth_params[:email], auth_params[:password]).call
    response = {
      message: Message.login_success,
      auth_token: auth_token
    }
    json_response(response, :created)
  rescue ExceptionHandler::AuthenticationError => e
    json_response({ error: e.message }, 400) 
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
