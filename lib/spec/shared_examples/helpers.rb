def get_option(method, option)
  described_class.instance_variable_get(:@simple_crud_metadata)[method][option]
end

%i[paginate authorize authenticate serializer].each do |option|
  define_method("check_#{option}") do |method|
    get_option(method, option)
  end
end

def model_class
  described_class.to_s.split('::')
                 .last.sub('Controller', '').singularize.underscore
end

def model_serializer
  defined?(serializer) ? serializer : "#{model.class}_serializer".classify.constantize
end

def model
  create(model_class)
end

def model_class_object
  model_class.classify.constantize
end

def policy_class_object
  "#{model_class_object}Policy".classify.constantize
end

def make_policies_fail(method)
  allow_any_instance_of(policy_class_object).to receive("#{method}?").and_return(false)
end

def make_policies_succeed(method)
  allow_any_instance_of(policy_class_object).to receive("#{method}?").and_return(true)
end

def model_params
  attributes_for(model_class)
end
