class DummyModelPolicy
  attr_reader :user, :dummy_model

  def initialize(user, dummy_model)
    @user = user
    @dummy_model = dummy_model
  end

  def check_user
    user == dummy_model.user
  end

  def show?
    check_user
  end

  def update?
    check_user
  end

  def create?
    check_user
  end

  def destroy?
    check_user
  end

  def index?
    check_user
  end
end
