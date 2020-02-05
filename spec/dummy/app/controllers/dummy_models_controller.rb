class DummyModelsController < ApplicationController
  include Wor::Paginate

  include Pundit
  extend SimpleCrudController

  before_action :set_params
  def set_params
    SimpleCrudController.params = params
  end

  def dummy_model_params
    params.permit(:name, :something, :user_id)
  end

  def dummy_model_filters
    params.permit(:by_name, :by_something, :by_user_id)
  end

  simple_crud
end
