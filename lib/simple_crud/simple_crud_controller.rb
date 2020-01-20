require 'byebug'
require 'active_support/all'
module SimpleCrudController
  cattr_accessor :params, :permitted

  # Possible options:
  ### authorize: use pundit to automatically check for authorization
  ### paginate: use wor-paginate to paginate the list
  ### authenticate: use devise to authenticate
  ### serializer: use a particular serializer (both each_serializer and serializer)
  def simple_crud_for(method, parameters = {})
    parameters = set_parameters(parameters)
    klass = simple_crud_controller_model
    check_valid_method(method)
    check_policies(parameters)
    check_serializer(parameters)
    define_method(method, send("crud_lambda_for_#{method}", klass, parameters))
    write_metadata(method, parameters)
  end

  def set_parameters(parameters)
    defaults = { authorize: true, paginate: true, authenticate: true, serializer: nil }
    defaults.each do |key, value|
      parameters[key] = value unless parameters.key?(key)
    end
    parameters
  end

  def write_metadata(method, parameters)
    @simple_crud_metadata ||= {}
    @simple_crud_metadata[method] = parameters
  end

  def crud_lambda_for_show(klass, parameters = {})
    lambda do
      authenticate_user! if parameters[:authenticate]
      requested = klass.find(params[:id])

      options = {}.merge(serializer: parameters[:serializer]).compact
      authorize requested if parameters[:authorize] && parameters[:authenticate]
      render({ json: requested }.merge(options))
    end
  end

  def crud_lambda_for_index(klass, parameters = {})
    lambda do
      authenticate_user! if parameters[:authenticate]
      authorize klass.new if parameters[:authorize] && parameters[:authenticate]
      paginate = parameters[:paginate]
      serializer = parameters[:serializer]
      options = {}.merge(each_serializer: serializer).compact

      paginate ? (render_paginated klass, options) : render({ json: klass.all }.merge(options))
    end
  end

  def crud_lambda_for_create(klass, parameters = {})
    lambda do
      authenticate_user! if parameters[:authenticate]
      permitted_params = send("#{self.class.simple_crud_controller_model.to_s.underscore}_params")
      authorize klass.new(permitted_params) if parameters[:authorize] && parameters[:authenticate]
      render json: klass.create!(permitted_params), status: :created
    end
  end

  def crud_lambda_for_update(klass, parameters = {})
    lambda do
      authenticate_user! if parameters[:authenticate]
      requested = klass.find(params[:id])
      authorize requested if parameters[:authorize] && parameters[:authenticate]
      permitted_params = send("#{self.class.simple_crud_controller_model.to_s.underscore}_params")
      render json: requested.update!(permitted_params)
    end
  end

  def crud_lambda_for_destroy(klass, parameters = {})
    lambda do
      authenticate_user! if parameters[:authenticate]
      requested = klass.find(params[:id])
      authorize requested if  parameters[:authorize] && parameters[:authenticate]
      render json: klass.find(params[:id]).destroy
    end
  end

  def simple_crud_controller_model
    to_s.split('::').last.sub('Controller', '').singularize.classify.constantize
  end

  def check_valid_method(method)
    throw 'invalid method' unless %i[show index create update destroy].include? method
  end

  def check_policies(parameters)
    return if !parameters.key?(:authorize) || !parameters[:authorize]

    policy_name = "#{simple_crud_controller_model}Policy"
    return if Kernel.const_defined?(policy_name)

    throw "create a valid policy with name #{policy_name}"
  end

  def check_serializer(parameters)
    return if parameters[:serializer].blank?

    serializer_name = parameters[:serializer].to_s
    return if Kernel.const_defined?(serializer_name)

    throw "create a valid serializer with name #{serializer_name}"
  end
end
