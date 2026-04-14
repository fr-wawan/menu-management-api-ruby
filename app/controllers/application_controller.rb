class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ArgumentError, with: :invalid_argument

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last

    unless token.present? && (@current_user = User.find_by(token: token))
      render json: { error: "Unauthorized. Please provide a valid token" }, status: :unauthorized
    end
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def invalid_argument(exception)
    render json: { errors: [ exception.message ] }, status: :unprocessable_entity
  end
end
