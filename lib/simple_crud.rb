require_relative 'simple_crud/simple_crud_controller'

module SimpleCrud
  VERSION = '0.1'.freeze
  def self.configure
    yield Config
  end
end
