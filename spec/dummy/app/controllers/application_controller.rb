class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Wor::Paginate
  include ActionController::MimeResponds
  respond_to :json
  before_action :authenticate_user!
  # i18n configuration. See: http://guides.rubyonrails.org/i18n.html
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::StatementInvalid, with: :unprocessable
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
  rescue_from ActionController::ParameterMissing, with: :unprocessable
  rescue_from Pundit::NotAuthorizedError, with: :forbidden
  # TODO: find a less general way to catch wrong enum values
  rescue_from ArgumentError, with: :unprocessable
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
