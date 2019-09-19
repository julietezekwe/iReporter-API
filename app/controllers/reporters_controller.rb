class ReportersController < ApplicationController
  def create
    user = Reporter.create!(user_params)
    auth_token = AuthenticateUser.new(user.name, user.email, user.password).call
    response = { 
      message: Message.account_created,
      auth_token: auth_token
    }
    render json: response , status: :created
  rescue ActiveRecord::RecordInvalid => e
    error_msg = Message.invalid_credentials
    error_msg = Message.account_exists if e.message.match?(/already been taken/)
    render json: { error: error_msg }, status: 422
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
