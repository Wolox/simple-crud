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

  simple_crud_for :create
  simple_crud_for :destroy, authenticate: false
  simple_crud_for :update
  simple_crud_for :show
  simple_crud_for :index
  end
