lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_crud"
require 'date'

Gem::Specification.new do |s|
  s.name        = "simple_crud"
  s.version     = SimpleCrud::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Date.today
  s.authors     = ["icoluccio"]
  s.email       = ["ignacio.coluccio@wolox.com.ar"]
  s.homepage    = "https://github.com/Wolox/simple-crud"
  s.summary     = "Simplified CRUD endpoints for Rails API controllers"
  s.description = "Simple CRUD is a gem for Rails that simplifies CRUD controllers, with default implementations and specs for common tasks"
  s.license     = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.require_paths = ['lib']

  s.add_dependency 'rails'
  s.add_dependency 'pundit'
  s.add_dependency 'devise_jwt_controllers'
  s.add_dependency 'fictium'
  s.add_dependency 'wor-paginate'
end
