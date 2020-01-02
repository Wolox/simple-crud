ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../spec/dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'pundit/rspec'
require 'wor/paginate/rspec'
include ActionDispatch::TestProcess
require 'simple_crud/rspec' 
require 'fictium/rspec'
require 'devise'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# VCR Configuration
# require 'vcr'
# require 'webmock/rspec'

# VCR.configure do |c|
#   c.ignore_hosts 'codeclimate.com'
#   c.cassette_library_dir = 'spec/cassettes'
#   c.hook_into :webmock
#   c.configure_rspec_metadata!
# end

# RSpec::Sidekiq.configure do |config|
#   config.warn_when_jobs_not_processed_by_sidekiq = false
# end

RSpec.configure do |config|
  config.include ActionDispatch::TestProcess
  config.file_fixture_path = Rails.root.join('spec', 'support', 'fixtures')

  config.infer_spec_type_from_file_location!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Response::JSONParser, type: :controller
  config.order = 'random'
end

ActiveRecord::Migration.maintain_test_schema!

Fictium.configure do |config|
  # You will require to configure the fixture path, if you want to use fixtures
  config.fixture_path = File.join(__dir__, 'support', 'docs')
end

RSpec::Matchers.define :have_been_serialized_with do |serializer|
  # TODO: Add support for optional relations `has_many :zarasa, if: zarasa2`
  # TODO: Support multilevel serialization
  match do |json_response|
    [json_response].flatten.all? do |json_response_item|
      all_attributes_included?(serializer._attributes, json_response_item) &&
        all_attributes_included?(serializer._reflections.keys, json_response_item)
    end
  end

  failure_message do |json_response|
    "expected attributes of #{serializer} serializer to be included in #{json_response}"
  end

  failure_message_when_negated do |json_response|
    "expected attributes of #{serializer} serializer not to be included in #{json_response}"
  end

  description do
    "checks to see if all the serializer's attributes are in the JSON response"
  end

  def all_attributes_included?(attributes, json_response)
    attributes.all? do |attribute|
      json_response.key?(attribute.to_s) || json_response.key?(attribute.to_sym)
    end
  end
end
