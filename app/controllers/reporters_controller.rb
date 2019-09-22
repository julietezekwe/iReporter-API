class ReportersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = Reporter.create!(user_params)
    auth_token = AuthenticateUser.new(user.name, user.email, user.password).call
    response = { 
      message: Message.account_created,
      auth_token: auth_token
    }
    json_response(response, :created)
  rescue ActiveRecord::RecordInvalid => e
    error_msg = Message.invalid_credentials
    error_msg = Message.account_exists if e.message.match?(/already been taken/)
    json_response({ error: error_msg }, 422)
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
