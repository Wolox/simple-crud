require 'simplecov'
require 'active_support/all'
SimpleCov.start
require File.expand_path('../../spec/dummy/config/environment.rb', __FILE__)
require 'fictium/rspec'
require 'devise/jwt/test_helpers'
require 'simple_crud/rspec'


ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../spec/dummy/db/migrate', __FILE__)]
RSpec.configure do |config|
  # config.include Devise::Test::ControllerHelpers, type: :controller
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Response::JSONParser, type: :controller
end



require 'rspec/rails'
require 'byebug'
