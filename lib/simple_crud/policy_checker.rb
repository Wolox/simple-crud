class PolicyChecker
  def check(parameters, model_name)
    return if !parameters.key?(:authorize) || !parameters[:authorize]

    policy_name = "#{model_name}Policy"
    return if Kernel.const_defined?(policy_name)

    throw "create a valid policy with name #{policy_name}"
  end
end
