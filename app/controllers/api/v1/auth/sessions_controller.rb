class Api::V1::Auth::SessionsController < ApplicationController
  before_action :authenticate_request, only: :destroy

  def create
    @user = User.find_by(email: params.dig(:user, :email))

    if @user&.authenticate(params.dig(:user, :password))
      render json: {
        message: "Login successful",
        token: @user.token,
        user: @user.as_json(only: %i[id name email created_at])
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    @current_user.regenerate_token
    render json: { message: "Logout successful" }
  end
end
