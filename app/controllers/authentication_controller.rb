class AuthenticationController < ApplicationController
  def authenticate
    auth_token = AuthenticateUser.new(nil, auth_params[:email], auth_params[:password]).call
    response = {
      message: Message.login_success,
      auth_token: auth_token
    }
    render json: response, status: :created
  rescue ExceptionHandler::AuthenticationError => e
    render json: { error: e.message }, status: 400
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
