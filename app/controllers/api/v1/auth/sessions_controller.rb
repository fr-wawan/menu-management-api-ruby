class Api::V1::Auth::SessionsController < ApplicationController
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
end
