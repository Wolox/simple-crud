def get_option(method, option)
  described_class.instance_variable_get(:@simple_crud_metadata)[method][option]
end

%i[paginate authorize authenticate serializer].each do |option|
  define_method("check_#{option}") do |method|
    get_option(method, option)
  end
end
