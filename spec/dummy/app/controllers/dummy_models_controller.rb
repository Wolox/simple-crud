class DummyModelsController < ApplicationController
  include Wor::Paginate

  include Pundit
  extend SimpleCrudController

  before_action :set_params
  def set_params
    SimpleCrudController.params = params
  end

  def dummy_model_params
    params.permit(:name, :something)
  end
  simple_crud_for :update, authenticate: false
  simple_crud_for :show, authenticate: false
  simple_crud_for :index, authenticate: false
  simple_crud_for :create, authenticate: false
  simple_crud_for :destroy, authenticate: false
end
