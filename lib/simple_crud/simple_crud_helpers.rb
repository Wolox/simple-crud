class SimpleCrudHelpers
  def self.permitted_params(that)
    that.send("#{simple_crud_controller_model(that).to_s.underscore}_params")
  end

  def self.controller_model(that)
    that.to_s.split('::').last.sub('Controller', '').singularize.classify.constantize
  end

  def self.simple_crud_controller_model(that)
    that = that.class unless that.is_a?(Class)
    that.to_s.split('::').last.sub('Controller', '').singularize.classify.constantize
  end

  def self.check_prerequirements(that, method, parameters)
    ValidMethodChecker.new.check(method)
    PolicyChecker.new.check(parameters, simple_crud_controller_model(that))
    SerializerChecker.new.check(parameters)
  end

  def self.filters(that)
    that.send("#{simple_crud_controller_model(that).to_s.underscore}_filters")
  end
end
