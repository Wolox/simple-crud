class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ActionController::MimeResponds
  respond_to :json

  include Wor::Paginate
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::StatementInvalid, with: :unprocessable
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
  rescue_from ActionController::ParameterMissing, with: :unprocessable
  rescue_from Pundit::NotAuthorizedError, with: :forbidden
  # rescue_from ArgumentError, with: :unprocessable
  def not_found(_exception)
    head :not_found
  end

  def unprocessable(exception)
    render json: { errors: exception }, status: :unprocessable_entity
  end

  def forbidden(exception)
    render json: { errors: exception }, status: :forbidden
  end
end
