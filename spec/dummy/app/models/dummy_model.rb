require_relative 'dummy_model_policy'
class DummyModel < ApplicationRecord
  belongs_to :user
end
