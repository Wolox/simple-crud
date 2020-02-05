class SerializerChecker
  def check(parameters)
    return if parameters[:serializer].blank?

    serializer_name = parameters[:serializer].to_s
    return if Kernel.const_defined?(serializer_name)

    throw "create a valid serializer with name #{serializer_name}"
  end
end
