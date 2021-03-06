# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'statusbot/api/version'

Gem::Specification.new do |spec|
  spec.name          = "statusbot-api"
  spec.version       = Statusbot::Api::VERSION
  spec.authors       = ["Eric Hayes"]
  spec.email         = ["eric@deployfx.com.com"]
  spec.summary       = %q{Public API for statusbot.me workers}
  spec.description   = %q{Provides API functionality to statusbot.me}
  spec.homepage      = "https://github.com/ejhayes/statusbot-api"
  spec.license       = "MIT"

  spec.files = Dir["{lib}/**/*"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'statusbot-models', '>= 0.6.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency "debugger"
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'database_cleaner'
end
