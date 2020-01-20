require 'rails_helper'
describe DummyModelsController, type: :controller do
  include_examples 'simple crud for update'
  include_examples 'simple crud for show'
  include_examples 'simple crud for create'
  include_examples 'simple crud for index'
  include_examples 'simple crud for destroy'
end
