class ValidMethodChecker
  ALL_METHODS = %i[show index create update destroy].freeze
  def check(method)
    throw "invalid method #{method}" unless ALL_METHODS.include? method
  end
end
