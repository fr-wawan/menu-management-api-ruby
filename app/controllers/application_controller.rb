class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ArgumentError, with: :invalid_argument

  private

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def invalid_argument(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end
