require 'byebug'
require 'active_support/all'
require_relative 'simple_crud_helpers'
require_relative 'simple_crud_method_helpers'
require_relative 'valid_method_checker'
require_relative 'policy_checker'
require_relative 'serializer_checker'
module SimpleCrudController
  cattr_accessor :params, :permitted

  def simple_crud(all_parameters = {})
    all_methods = %i[show index destroy create update]
    methods_to_create = all_parameters[:only] || all_methods - [all_parameters[:except]]
    methods_to_create.each do |method|
      simple_crud_for(method, all_parameters.except(:only, :except))
    end
  end

  # Possible options:
  ### authorize: use pundit to automatically check for authorization
  ### paginate: use wor-paginate to paginate the list
  ### authenticate: use devise to authenticate
  ### serializer: use a particular serializer (both each_serializer and serializer)
  ### filter: use toscha-filterable to filter
  def simple_crud_for(method, parameters = {})
    parameters = with_default_parameters(parameters)
    klass = SimpleCrudHelpers.controller_model(self)
    SimpleCrudHelpers.check_prerequirements(self, method, parameters)
    define_method(method, send("crud_lambda_for_#{method}", klass, parameters))
    write_metadata(method, parameters)
  end

  def with_default_parameters(parameters)
    parameters.with_defaults(authorize: true, paginate: true, authenticate: true,
                             serializer: nil, filter: true)
  end

  def write_metadata(method, parameters)
    @simple_crud_metadata ||= {}
    @simple_crud_metadata[method] = parameters
  end

  def crud_lambda_for_show(klass, parameters = {})
    lambda do
      SimpleCrudMethodHelpers.authenticate(self, parameters)
      requested = klass.find(params[:id])

      options = {}.merge(serializer: parameters[:serializer]).compact
      authorize requested if parameters[:authorize]
      render({ json: requested }.merge(options))
    end
  end

  def crud_lambda_for_index(query, parameters = {})
    lambda do
      SimpleCrudMethodHelpers.authenticate(self, parameters)
      authorize query.new if parameters[:authorize]
      options = {}.merge(each_serializer: parameters[:serializer]).compact
      to_render = SimpleCrudMethodHelpers.filter(self, query, parameters)
      return render_paginated to_render, options if parameters[:paginate]

      render({ json: to_render.all }.merge(options))
    end
  end

  def crud_lambda_for_create(klass, parameters = {})
    lambda do
      SimpleCrudMethodHelpers.authenticate(self, parameters)
      permitted_params = SimpleCrudHelpers.permitted_params(self)
      authorize klass.new(permitted_params) if parameters[:authorize]
      render json: klass.create!(permitted_params), status: :created
    end
  end

  def crud_lambda_for_update(klass, parameters = {})
    lambda do
      SimpleCrudMethodHelpers.authenticate(self, parameters)
      requested = klass.find(params[:id])
      authorize requested if parameters[:authorize]
      permitted_params = SimpleCrudHelpers.permitted_params(self)
      render json: requested.update!(permitted_params)
    end
  end

  def crud_lambda_for_destroy(klass, parameters = {})
    lambda do
      SimpleCrudMethodHelpers.authenticate(self, parameters)
      requested = klass.find(params[:id])
      authorize requested if parameters[:authorize]
      render json: requested.destroy
    end
  end
end
