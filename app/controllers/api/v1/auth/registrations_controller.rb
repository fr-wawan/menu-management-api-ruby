class Api::V1::Auth::RegistrationsController < ApplicationController
  def create
    @user = User.new(registration_params)

    if @user.save
      render json: {
        message: "Registration successful",
        token: @user.token,
        user: @user.as_json(only: %i[id name email created_at])
      }, status: :created
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_content
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
