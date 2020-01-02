class DummyModelPolicy
  attr_reader :user, :author

  def initialize(user, dummy_model)
    @user = user
    @dummy_model = dummy_model
  end

  def show?
    user.present?
  end

  def update?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    user.present?
  end

  def index?
    user.present?
  end
end
