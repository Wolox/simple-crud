class AddUserIdToDummyModels < ActiveRecord::Migration[6.0]
  def change
    add_reference :dummy_models, :user, foreign_key: true
  end
end
