require_relative 'simple_crud/simple_crud_controller'

module SimpleCrud
  VERSION = '0.2'.freeze
  def self.configure
    yield Config
  end
end
